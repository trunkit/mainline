class AddItemsCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :items_count, :integer
  end
end
