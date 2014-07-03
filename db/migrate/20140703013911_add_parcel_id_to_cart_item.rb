class AddParcelIdToCartItem < ActiveRecord::Migration
  def change
    add_column(:cart_items, :parcel_id, :text)
  end
end
