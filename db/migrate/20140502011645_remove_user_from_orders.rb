class RemoveUserFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :user, :integer
  end
end
