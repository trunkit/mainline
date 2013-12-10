class ItemPhoto < ActiveRecord::Base
  mount_uploader :url, ItemPhotoUploader
end
