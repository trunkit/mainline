class ChangeDefaultApprovedOnItems < ActiveRecord::Migration
  def change
    change_column_null(:items, :approved, false)
    change_column_default(:items, :approved, false)
  end
end
