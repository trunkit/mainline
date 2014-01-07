class Item < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :parent, class_name: "Item"
  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :options,  class_name: "ItemOption"
  has_many :photos,   class_name: "ItemPhoto"
  has_many :children, class_name: "Item", foreign_key: :parent_id, dependent: :destroy

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id

  def primary_photo
    photos.first || photos.build
  end

  def supplier
    parent ? parent.boutique : boutique
  end
end
