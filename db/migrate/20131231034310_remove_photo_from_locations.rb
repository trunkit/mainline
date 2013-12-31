class RemovePhotoFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :photo, :string
  end
end
