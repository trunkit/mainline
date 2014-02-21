class Item < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  searchable do
    text :name, :description, :fit, :construction, :model_measurements
    text :categories do
      categories.map(&:name)
    end

    text :boutique do
      boutique.name
    end

    text :brand do
      brand.name
    end

    text :cities do
      boutique.locations.map(&:city)
    end

    text :states do
      boutique.locations.map(&:state)
    end

    integer :boutique_id, :brand_id
    integer :category_ids, multiple: true
    double  :price
  end

  belongs_to :parent, class_name: "Item"
  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :options,  class_name: "ItemOption"
  has_many :photos,   class_name: "ItemPhoto"
  has_many :children, class_name: "Item", foreign_key: :parent_id, dependent: :destroy

  has_and_belongs_to_many :categories

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id

  scope :for_category, ->(name_or_id) {
    conditions = name_or_id.is_a?(Fixnum) ? { "categories.id" => name_or_id } : { "categories.name" => name_or_id }
    includes(:categories).references(:categories).where(conditions)
  }

  def self.for_stream(params)
    scope = all
    scope = scope.for_category(params[:category]) if params[:category].present?
    scope.order(created_at: :desc)
  end

  def self.discover(params)
    per_page = params[:per_page].to_i
    per_page = 20 if per_page < 1 || per_page > 100

    page = params[:page].to_i
    page = 1 if page < 1

    search do
      fulltext(params[:q])

      paginate(page: page, per_page: per_page)
    end
  end

  def primary_photo
    photos.first || photos.build
  end

  def supplier
    parent ? parent.boutique : boutique
  end

  def version
    versions.count + 1
  end
end
