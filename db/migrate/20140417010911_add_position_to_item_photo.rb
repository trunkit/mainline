class AddPositionToItemPhoto < ActiveRecord::Migration
  def change
    add_column :item_photos, :position, :integer
  end
end
