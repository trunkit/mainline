class AddApiTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_token, :text
  end
end
