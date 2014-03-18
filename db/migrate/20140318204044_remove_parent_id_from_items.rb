class RemoveParentIdFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :parent_id, :integer
  end
end
