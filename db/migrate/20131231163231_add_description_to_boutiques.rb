class AddDescriptionToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :description, :string
  end
end
