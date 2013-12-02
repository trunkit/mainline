class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :order
      t.references :user

      t.timestamps
    end
  end
end
