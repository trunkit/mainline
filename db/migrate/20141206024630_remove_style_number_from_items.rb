class RemoveStyleNumberFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :style_number, :string
  end
end
