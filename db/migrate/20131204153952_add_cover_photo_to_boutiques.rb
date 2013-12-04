class AddCoverPhotoToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :cover_photo, :string
  end
end
