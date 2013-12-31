class Location < ActiveRecord::Base
  belongs_to :company, polymorphic: true
  has_one    :address, as: :parent

	accepts_nested_attributes_for :address

	mount_uploader :cover_photo,  CoverPhotoUploader
	mount_uploader :stream_photo, StreamPhotoUploader
end
