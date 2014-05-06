class AddCreatedAtAndUpdatedAtToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :created_at, :datetime
    add_column :boutiques, :updated_at, :datetime
  end
end
