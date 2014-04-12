class AddSizesToItem < ActiveRecord::Migration
  def change
    add_column :items, :sizes, :json
  end
end
