class RenameRefundIdToCancellationRefundIdOnCartItems < ActiveRecord::Migration
  def change
    rename_column(:cart_items, :refund_id, :cancellation_refund_id)
  end
end
