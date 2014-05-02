class AddShippingToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :shipping, :decimal, precision: 5, scale: 2
  end
end
