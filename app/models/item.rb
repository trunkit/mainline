class Item < ActiveRecord::Base
  has_many :photos, class_name: "ItemPhotos"
  has_many :options, class_name: "ItemOptions"
end
