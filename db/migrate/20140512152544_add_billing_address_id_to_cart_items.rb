class AddBillingAddressIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :billing_address_id, :integer
  end
end
