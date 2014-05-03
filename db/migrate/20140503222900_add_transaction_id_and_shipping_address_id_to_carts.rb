class AddTransactionIdAndShippingAddressIdToCarts < ActiveRecord::Migration
  def change
    add_column(:carts, :transaction_id, :text)
    add_reference(:carts, :shipping_address)
  end
end
