class AddRefundRequestedToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :refund_requested, :boolean, default: false
  end
end
