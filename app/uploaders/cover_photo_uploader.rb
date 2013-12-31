# encoding: utf-8

class CoverPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :banner do
    process resize_to_fill: [915, 300]
  end

  version :thumb do
    process resize_to_fill: [62, 62]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
