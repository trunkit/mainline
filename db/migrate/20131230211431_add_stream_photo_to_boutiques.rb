class AddStreamPhotoToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :stream_photo, :string
  end
end
