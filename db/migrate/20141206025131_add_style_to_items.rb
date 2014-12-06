class AddStyleToItems < ActiveRecord::Migration
  def change
    add_column :items, :style, :string
  end
end
