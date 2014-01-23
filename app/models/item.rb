class Item < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

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

  def primary_photo
    photos.first || photos.build
  end

  def supplier
    parent ? parent.boutique : boutique
  end
end
