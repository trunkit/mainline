class RemoveColumnTitsFFun < ActiveRecord::Migration
  def change
  	remove_column :customer_orders, :tits
  	remove_column :customer_orders, :fun
  end
end
