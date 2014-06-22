class AddLedgerEntryIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :ledger_entry_id, :integer
  end
end
