class AddStreamPhotoAndCoverPhotoToBoutiques < ActiveRecord::Migration
  def change
    add_column(:boutiques, :stream_photo, :text)
    add_column(:boutiques, :cover_photo, :text)
  end
end
