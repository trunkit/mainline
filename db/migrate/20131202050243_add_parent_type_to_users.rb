class AddParentTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parent_type, :string
  end
end
