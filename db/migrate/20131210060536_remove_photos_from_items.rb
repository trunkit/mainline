class RemovePhotosFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :photos, :string
  end
end
