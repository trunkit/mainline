class AddCoverPhotoAndStreamPhotoToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :cover_photo, :string
    add_column :locations, :stream_photo, :string
  end
end
