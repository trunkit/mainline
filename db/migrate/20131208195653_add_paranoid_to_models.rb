class AddParanoidToModels < ActiveRecord::Migration
  def change
    add_column :boutiques,    :deleted_at, :datetime
    add_column :carts,        :deleted_at, :datetime
    add_column :designers,    :deleted_at, :datetime
    add_column :item_options, :deleted_at, :datetime
  end
end
