class ChangeCategoryRelationOnItems < ActiveRecord::Migration
  def change
    drop_table :categories_items

    change_table :items do |t|
      t.integer :primary_category_id, :secondary_category_id
    end
  end
end
