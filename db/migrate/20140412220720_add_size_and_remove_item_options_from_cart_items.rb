class AddSizeAndRemoveItemOptionsFromCartItems < ActiveRecord::Migration
  def change
    change_table :cart_items do |t|
      t.string :size
      t.remove :item_options
    end
  end
end
