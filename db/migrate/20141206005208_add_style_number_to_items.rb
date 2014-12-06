class AddStyleNumberToItems < ActiveRecord::Migration
  def change
    add_column :items, :style_number, :string
  end
end
