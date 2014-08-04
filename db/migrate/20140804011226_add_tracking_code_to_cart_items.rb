class AddTrackingCodeToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :tracking_code, :text
  end
end
