class Item < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  belongs_to :parent, class_name: "Item"
  belongs_to :boutique, counter_cache: true
  belongs_to :brand

  has_many :options, class_name: "ItemOptions"
  has_many :photos,  class_name: "ItemPhoto"

  validates_presence_of :name, :price, :description, :brand_id, :boutique_id
end
