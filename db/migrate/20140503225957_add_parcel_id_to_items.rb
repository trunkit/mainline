class AddParcelIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :parcel_id, :text
  end
end
