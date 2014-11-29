class AddItemToCustomerOrders < ActiveRecord::Migration
  def change
    add_column :customer_orders, :item_id, :integer
  end
end
