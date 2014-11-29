class RemoveItemFromCustomerOrders < ActiveRecord::Migration
  def change
    remove_column :customer_orders, :item, :string
  end
end
