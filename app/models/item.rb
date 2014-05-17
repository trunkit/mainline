class Item < ActiveRecord::Base
  include Elasticsearch::Model

  after_commit(on: [:create, :update]) { __elasticsearch__.index_document }
  after_commit(on: [:destroy])         { __elasticsearch__.remove_document }

  index_name    "trunkit"
  document_type "item"

  acts_as_paranoid
  has_paper_trail

  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :photos, -> { order("position ASC") }, class_name: "ItemPhoto"

  belongs_to :primary_category,   class_name: "Category"
  belongs_to :secondary_category, class_name: "Category"

  after_destroy :remove_activity_entry

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id

  scope :for_category, ->(id) {
    where("primary_category_id = ? OR secondary_category_id = ?", id.to_i, id.to_i)
  }

  before_save do
    self.parcel_id = parcel.id
  end

  def self.for_stream(user, params)
    boutique_ids   = params[:boutique_id]
    boutique_ids ||= user.boutiques_following.select(:id).map(&:id) if user

    actions = user && user.parent_id.present? ? ['support', 'added'] : 'support'

    activity_scope = Activity.where({
      owner_type:   "Boutique",
      action:       actions,
      subject_type: "Item"
    }).order(created_at: :desc)

    activity_scope = activity_scope.where(owner_id: boutique_ids) if boutique_ids.present?

    item_ids = activity_scope.select(:subject_id).map(&:subject_id)

    items = Item.where(id: item_ids)
    items = items.for_category(params[:category]) if params[:category].present?
    items = items.includes(:boutique).page(params[:page] || 1).per(params[:per] || 30)

    activities = activity_scope.where(subject_id: items.map(&:id))
    activities.map{|activity| [activity, items.detect{|i| i.id == activity.subject_id }] }
  end

  def self.discover(params)
    per = params[:per_page].to_i
    per = 20 if per < 1 || per > 100

    page = params[:page].to_i
    page = 1 if page < 1

    query = {
      query: {
        multi_match: {
          query:  params[:q],
          fields: ['name', 'description', 'fit', 'construction', 'model_measurements', 'categories', 'boutique_name', 'brand_name', 'cities', 'states'],
          max_expansions: 5,
          type: "phrase_prefix"
        }
      }
    }

    search(query).page(page).per(per).records
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
    return false if supporter_ids.include?(boutique.id)

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

  def parcel
    @parcel ||= EasyPost::Parcel.create({
      width:  packaging_width,
      length: packaging_length,
      height: packaging_height,
      weight: weight
    })
  end

  def version
    versions.count + 1
  end

  def as_indexed_json(options = {})
    hsh = as_json(except: [:id])

    hsh[:boutique_name] = boutique.name
    hsh[:brand_name]    = brand.name
    hsh[:categories]    = [primary_category.try(:name), secondary_category.try(:name)].compact.uniq
    hsh[:cities]        = boutique.address.city
    hsh[:states]        = boutique.address.state

    hsh
  end

private

  def add_activity_entry
    Activity.
      for_subject(self).
      for_owner(boutique).
      create({ action: 'added' })
  end

  def remove_activity_entry
    Activity.
      for_subject(self).
      for_owner(boutique).
      where({ action: 'added' }).
      each(&:destroy)
  end
end
