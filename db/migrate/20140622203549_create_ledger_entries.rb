class CreateLedgerEntries < ActiveRecord::Migration
  def change
    create_table :ledger_entries do |t|
      t.integer    :user_id
      t.decimal    :value, precision: 9, scale: 2
      t.text       :description
      t.references :whodunnit, polymorphic: true, index: true

      t.timestamps
    end
  end
end
