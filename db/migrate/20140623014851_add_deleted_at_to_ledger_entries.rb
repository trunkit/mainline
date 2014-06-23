class AddDeletedAtToLedgerEntries < ActiveRecord::Migration
  def change
    add_column :ledger_entries, :deleted_at, :datetime
  end
end
