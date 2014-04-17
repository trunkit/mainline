class ItemPhoto < ActiveRecord::Base
  belongs_to :item

  mount_uploader :url, StreamPhotoUploader

  validates_presence_of :url
end
