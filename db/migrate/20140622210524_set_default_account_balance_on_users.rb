class SetDefaultAccountBalanceOnUsers < ActiveRecord::Migration
  def change
    User.all.each{|u| u.update_attributes(account_balance: 0) }
    change_column_default(:users, :account_balance, 0)
  end
end
