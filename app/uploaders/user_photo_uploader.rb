# encoding: utf-8

class UserPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [1000,1000]

  version :thumb do
    process scale: [25, 25]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
