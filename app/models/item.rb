class Item < ActiveRecord::Base
  include Elasticsearch::Model

  after_commit(on: [:create, :update]) { __elasticsearch__.index_document }
  after_commit(on: [:destroy])         { __elasticsearch__.remove_document }

  index_name    "trunkit"
  document_type "item"

  mapping do
    # Primary Attributes
    indexes :name,          type: "string", analyzer: "english"
    indexes :price,         type: "float"
    indexes :description,   type: "string", analyzer: "english"
    indexes :fit,           type: "string", analyzer: "english"
    indexes :construction,  type: "string", analyzer: "english"
    indexes :model_height,  type: "float", index: "no"
    indexes :model_chest,   type: "float", index: "no"
    indexes :model_waist,   type: "float", index: "no"
    indexes :model_hips,    type: "float", index: "no"
    indexes :model_size,    type: "string", index: "no"
    indexes :approved,      type: "boolean"
    indexes :boutique_name, type: "string", analyzer: "english"
    indexes :brand_name,    type: "string", analyzer: "english"
    indexes :categories,    type: "string", analyzer: "english"
    indexes :supporters,    index: "not_analyzed"

    # Location
    indexes :address do
      indexes :id,          type: "integer", index: "no"
      indexes :street,      type: "string", index: "no"
      indexes :street2,     type: "string", index: "no"
      indexes :city,        type: "string", analyzer: "english"
      indexes :state,       type: "string", analyzer: "english"
      indexes :state_abbr,  type: "string", index: "not_analyzed"
      indexes :postal_code, index: "no"
    end

    # Shipping
    indexes :weight,           type: "float", index: "no"
    indexes :packaging_width,  type: "float", index: "no"
    indexes :packaging_height, type: "float", index: "no"
    indexes :packaging_length, type: "float", index: "no"

    # Foreign Keys
    indexes :boutique_id,           type: "integer", index: "no"
    indexes :brand_id,              type: "integer", index: "no"
    indexes :parcel_id,             type: "string",  index: "no"
    indexes :primary_category_id,   type: "integer", index: "no"
    indexes :secondary_category_id, type: "integer", index: "no"

    # Timestamps
    indexes :deleted_at, type: "date", format: "date_time", index: "no"
    indexes :created_at, type: "date", format: "date_time", index: "no"
    indexes :updated_at, type: "date", format: "date_time", index: "no"
  end

  acts_as_paranoid
  has_paper_trail

  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :photos, -> { order("position ASC") }, class_name: "ItemPhoto"

  belongs_to :primary_category,   class_name: "Category"
  belongs_to :secondary_category, class_name: "Category"

  after_update  :check_for_owner_change
  after_destroy :remove_activity_entry

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id

  scope :for_category, ->(id) {
    where("primary_category_id = ? OR secondary_category_id = ?", id.to_i, id.to_i)
  }

  after_destroy :remove_from_carts!

  class << self
    def for_stream(user, params)
      boutique_ids   = params[:boutique_id]
      boutique_ids ||= user.boutiques_following.select(:id).map(&:id) if user

      activity_scope = item_activity_scope(user)
      activity_scope = activity_scope.where(owner_id: boutique_ids) if boutique_ids.present?
      activity_scope = activity_scope.where.not("(owner_id = ? AND action = 'support')", user.parent_id) if user && user.parent_id.present?

      item_ids = activity_scope.select(:subject_id).map(&:subject_id)

      items = Item.where(id: item_ids, approved: true)
      items = items.for_category(params[:category]) if params[:category].present?
      items = items.includes(:boutique).page(params[:page] || 1).per(params[:per] || 30)

      activities = activity_scope.where(subject_id: items.map(&:id))
      activities.map{|activity| [activity, items.detect{|i| i.id == activity.subject_id }] }
    end

    def discover(user, params)
      per = params[:per_page].to_i
      per = 20 if per < 1 || per > 100
      per = 1000

      page = params[:page].to_i
      page = 1 if page < 1

      fields  = ['name', 'description', 'fit', 'construction', 'categories', 'brand_name', 'cities', 'states', 'supporters']
      fields << 'boutique_name' if user.parent_id.present?

      query = {
        query: {
          multi_match: {
            query:  params[:q],
            fields: fields,
            max_expansions: 5,
            type: "phrase_prefix"
          }
        }
      }

      if user.parent_id.blank?
        query.merge!(filter: {
          not: {
            missing: { field: "supporters" }
          }
        })

        query = { query: { filtered: query }}
      end

      items = search(query).page(page).per(per).records.where(approved: true).includes(:boutique, :brand)

      activities = item_activity_scope(user).where(subject_id: items.map(&:id)).index_by(&:subject_id)
      items.map{|i| [activities[i.id], i] }
    end

  private
    def item_activity_scope(user = nil)
      actions = user && user.parent_id.present? ? ['support', 'added'] : 'support'

      activity_scope = Activity.where({
        owner_type:   "Boutique",
        action:       actions,
        subject_type: "Item"
      }).order(created_at: :desc)
    end
  end

  def sizes
    self[:sizes] || {}
  end

  def grant_approval!
    self.class.transaction do
      update_attribute(:approved, true)
      add_activity_entry
    end
  end

  def revoke_approval!
    self.class.transaction do
      update_attribute(:approved, false)
      remove_activity_entry
    end
  end

  def add_supporter(boutique)
    return false if declined_boutique_ids.include?(boutique.id) || supporter_ids.include?(boutique.id)

    Activity.
      for_owner(boutique).
      for_subject(self).
      create({ action: "support" })
  end

  def remove_supporter(boutique)
    activity = Activity.for_subject(self).for_owner(boutique).where(action: "support").first
    activity.try(:destroy)
  end

  # False if not favorited,
  # True if is now a favorite
  def toggle_favorite(user)
    scope = Activity.for_subject(self).for_owner(user).where(action: "favorite")

    if activity = scope.first
      activity.destroy
      false
    else
      scope.create
      true
    end
  end

  def decline_boutique(boutique)
    boutique = Boutique.find(boutique) unless boutique.is_a?(Boutique)

    declined_boutique_ids_will_change!
    declined_boutique_ids << boutique.id
    save

    remove_supporter(boutique)

    true
  end

  def supporter_ids(reload = false)
    return @supporters if @supporters && !reload

    activities = Activity.for_subject(self).where(action: "support", owner_type: "Boutique").select(:owner_id)
    @supporter_ids = activities.map(&:owner_id)
  end

  def supporters(reload = false)
    @supporters   = nil if reload
    @supporters ||= Boutique.find(supporter_ids(reload))
  end

  def primary_photo
    photos.first || photos.build
  end

  def has_measurements?
    [:model_height, :model_chest, :model_hips, :model_waist, :model_size].map{|f| send(f) }.any?{|v| v.present? }
  end

  def active_sizes
    sizes.select{|size,qty| qty.to_i > 0 }.map(&:first)
  end

  def declined_boutique_ids
    self[:declined_boutique_ids] ||= []
  end

  def version
    versions.count + 1
  end

  def notify(action, subject)
    if action == 'support' || action == 'unsupport'
      __elasticsearch__.index_document
    end
  end

  def as_indexed_json(options = {})
    hsh = as_json
    hsh.delete("sizes")

    hsh["boutique_name"] = boutique.name
    hsh["brand_name"]    = brand.name
    hsh["categories"]    = [primary_category.try(:name), secondary_category.try(:name)].compact.uniq
    hsh["address"]       = boutique.address.as_indexed_json
    hsh["supporters"]    = supporters.present? ? supporters.map(&:name) : nil

    hsh
  end

private
  def check_for_owner_change
    return true unless approved?

    if previous_changes.keys.include?("boutique_id")
      Activity.
        for_subject(self).
        where(owner_id: previous_changes["boutique_id"], owner_type: "Boutique", action: "added").
        each(&:destroy)

      add_activity_entry
    end
  end

  def add_activity_entry
    Activity.
      for_subject(self).
      for_owner(boutique).
      create({ action: 'added' })
  end

  def remove_activity_entry
    Activity.
      for_subject(self).
      each(&:destroy)
  end

  def remove_from_carts!
    CartItem.where(item_id: id).includes(:cart).each{|ci| ci.destroy unless ci.purchased? }
    true
  end
end
