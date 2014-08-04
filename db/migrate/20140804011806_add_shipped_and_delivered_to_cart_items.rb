class AddShippedAndDeliveredToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :shipped,   :boolean, default: false
    add_column :cart_items, :delivered, :boolean, default: false
  end
end
