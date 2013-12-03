class AddDefaultToItemPhotos < ActiveRecord::Migration
  def change
    change_column_default :items, :photos, '{}'
  end
end
