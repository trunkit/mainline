class CreateItemOptions < ActiveRecord::Migration
  def change
    create_table :item_options do |t|
      t.references :item
      t.string     :name
      t.string     :value
      t.decimal    :price

      t.timestamps
    end
  end
end
