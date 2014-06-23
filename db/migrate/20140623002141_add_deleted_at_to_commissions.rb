class AddDeletedAtToCommissions < ActiveRecord::Migration
  def change
    add_column :commissions, :deleted_at, :datetime
  end
end
