class Item < ActiveRecord::Base
  belongs_to :parent, class_name: "Item"
  belongs_to :boutique, counter_cache: true

  has_many :options, class_name: "ItemOptions"
end
