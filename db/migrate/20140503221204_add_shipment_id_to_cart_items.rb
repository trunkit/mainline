class AddShipmentIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :shipment_id, :text
  end
end
