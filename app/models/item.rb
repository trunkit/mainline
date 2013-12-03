class Item < ActiveRecord::Base
  belongs_to :parent, class_name: "Item"
  belongs_to :boutique

  has_many :options, class_name: "ItemOptions"
end
