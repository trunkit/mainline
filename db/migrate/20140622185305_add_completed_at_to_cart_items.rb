class AddCompletedAtToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :completed_at, :datetime
  end
end
