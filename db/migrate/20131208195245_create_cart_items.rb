class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :cart_id, :item_id, :item_version, null: false
      t.hstore  :item_options

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
