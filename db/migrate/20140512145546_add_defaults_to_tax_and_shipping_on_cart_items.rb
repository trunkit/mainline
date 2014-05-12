class AddDefaultsToTaxAndShippingOnCartItems < ActiveRecord::Migration
  def change
    change_column_default(:cart_items, :shipping, 0.0)
    change_column_default(:cart_items, :tax, 0.0)
  end
end
