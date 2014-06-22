class AddRefundLedgerEntryIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :refund_ledger_entry_id, :integer
  end
end
