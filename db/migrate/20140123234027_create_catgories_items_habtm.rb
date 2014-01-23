class CreateCatgoriesItemsHabtm < ActiveRecord::Migration
  def change
    create_table :categories_items, id: false do |t|
      t.references :category, :item
    end

    add_index :categories_items, [:category_id, :item_id]
  end
end
