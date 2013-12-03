class Item < ActiveRecord::Base
  has_many :photos, class_name: "ItemPhotos"
  belongs_to :parent, class_name: "Item"

  has_many :options, class_name: "ItemOptions"
end
