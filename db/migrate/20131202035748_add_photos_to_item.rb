class AddPhotosToItem < ActiveRecord::Migration
  def change
    add_column :items, :photos, :string, array: true
  end
end
