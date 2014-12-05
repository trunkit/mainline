class ChangItemColumn < ActiveRecord::Migration
  def change
  	#remove_column :customer_orders, :item
  	add_column :customer_orders, :fun, :integer
  end
end
