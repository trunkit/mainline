class AddTrunksaleoptionToItems < ActiveRecord::Migration
  def change
    add_column :items, :list_on_trunksale, :integer
  end
end
