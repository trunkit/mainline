class AddStyleNumberToItem < ActiveRecord::Migration
  def change
  	add_column :items, :style_number, :text
  end
end
