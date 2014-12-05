class AddTitsToCustomerOrders < ActiveRecord::Migration
  def change
    add_column :customer_orders, :tits, :integer
  end
end
