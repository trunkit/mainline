class AddShippingRateIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :shipping_rate_id, :text
  end
end
