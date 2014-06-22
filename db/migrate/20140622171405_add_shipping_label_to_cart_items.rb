class AddShippingLabelToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :shipping_label, :json
  end
end
