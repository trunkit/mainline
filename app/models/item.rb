class Item < ActiveRecord::Base
  include Elasticsearch::Model

  acts_as_paranoid
  has_paper_trail

  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :options, class_name: "ItemOption"
  has_many :photos,  class_name: "ItemPhoto"

  has_and_belongs_to_many :categories

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id

  scope :for_category, ->(name_or_id) {
    conditions = name_or_id.is_a?(Fixnum) ? { "categories.id" => name_or_id } : { "categories.name" => name_or_id }
    includes(:categories).references(:categories).where(conditions)
  }

  def self.for_stream(params)
    scope = all
    scope = scope.for_category(params[:category]) if params[:category].present?
    scope = scope.includes(:boutique)
    scope.order(created_at: :desc)
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

  def support(boutique)
    return false if supporter_ids.include?(boutique.id)

    Activity.
      for_owner(boutique).
      for_subject(self).
      create({ action: "support" })
  end

  def unsupport(boutique)
    activity = Activity.for_subject(self).for_owner(boutique).where(action: "support").first
    activity.try(:destroy)
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

  def version
    versions.count + 1
  end

  def as_indexed_json(options = {})
    hsh = as_json(except: [:id])

    hsh[:categories]    = categories.map(&:name)
    hsh[:boutique_name] = boutique.name
    hsh[:brand_name]    = brand.name
    hsh[:cities]        = boutique.locations.map(&:city)
    hsh[:states]        = boutique.locations.map(&:state)

    hsh
  end
end
