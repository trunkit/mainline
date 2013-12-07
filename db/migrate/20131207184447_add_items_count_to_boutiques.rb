class AddItemsCountToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :items_count, :integer
  end
end
