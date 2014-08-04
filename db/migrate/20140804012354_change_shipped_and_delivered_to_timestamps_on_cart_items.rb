class ChangeShippedAndDeliveredToTimestampsOnCartItems < ActiveRecord::Migration
  def change
    remove_column :cart_items, :shipped
    remove_column :cart_items, :delivered

    add_column :cart_items, :shipped_at,   :datetime
    add_column :cart_items, :delivered_at, :datetime
  end
end
