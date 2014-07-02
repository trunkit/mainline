class AddRefundableToCartItem < ActiveRecord::Migration
  def change
    add_column :cart_items, :refundable, :boolean, default: true
  end
end
