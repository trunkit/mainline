class AddWeightToItems < ActiveRecord::Migration
  def change
    add_column :items, :weight, :decimal, precision: 5, scale: 2, default: 1.0
  end
end
