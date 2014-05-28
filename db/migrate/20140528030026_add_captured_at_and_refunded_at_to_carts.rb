class AddCapturedAtAndRefundedAtToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :captured_at, :datetime
    add_column :carts, :refunded_at, :datetime
  end
end
