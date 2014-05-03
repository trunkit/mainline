class AddTaxToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :tax, :decimal, precision: 9, scale: 2
  end
end
