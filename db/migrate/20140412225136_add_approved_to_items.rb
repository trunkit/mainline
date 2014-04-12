class AddApprovedToItems < ActiveRecord::Migration
  def change
    add_column :items, :approved, :boolean
  end
end
