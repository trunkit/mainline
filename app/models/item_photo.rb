class ItemPhoto < ActiveRecord::Base
  belongs_to :item

  mount_uploader :url, ItemPhotoUploader
end
