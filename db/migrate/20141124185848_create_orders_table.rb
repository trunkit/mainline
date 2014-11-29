class CreateOrdersTable < ActiveRecord::Migration
  def change
    create_table :customer_orders do |t|
   		t.string :name
      t.integer :boutique_id
   		t.string :order_number
   		t.string :customer_name
   		t.datetime :created_at
   		t.datetime :updated_at
   		t.string :shipping_label
      t.integer :fulfillment_status
      t.integer :item
    end
  end
end
