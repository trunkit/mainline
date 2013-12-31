class RemoveCoverPhotoAndStreamPhotoFromBoutiques < ActiveRecord::Migration
  def change
    remove_column :boutiques, :cover_photo, :string
    remove_column :boutiques, :stream_photo, :string
  end
end
