class AddDiscountToItems < ActiveRecord::Migration
  def change
    add_column :items, :discount_amount, :decimal
  end
end
