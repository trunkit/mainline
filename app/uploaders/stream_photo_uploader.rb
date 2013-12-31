# encoding: utf-8

class StreamPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  process resize_to_fit: [1000, 1000]

  version :stream do
    process resize_to_fill: [300, 362]
  end

  version :details do
    process resize_to_fit: [288, 378]
  end

  version :thumb do
    process resize_to_fit: [62, 62]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
