class AddStuffToCustomerOrders < ActiveRecord::Migration
  def change
    add_column :customer_orders, :item_id, :integer
    add_column :customer_orders, :item_size, :string
  end
end
