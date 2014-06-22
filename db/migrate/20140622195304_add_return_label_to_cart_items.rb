class AddReturnLabelToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :return_label, :json
  end
end
