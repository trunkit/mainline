class AddRefundIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :refund_id, :text
  end
end
