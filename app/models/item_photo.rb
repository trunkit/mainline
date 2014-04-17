class ItemPhoto < ActiveRecord::Base
  belongs_to :item
  acts_as_list scope: :item

  mount_uploader :url, StreamPhotoUploader

  validates_presence_of :url
end
