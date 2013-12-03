class AddPrimaryToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :primary, :boolean, default: false
  end
end
