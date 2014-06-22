class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.integer :cart_item_id, :boutique_id
      t.text    :recipient_id, :transfer_id
      t.decimal :value

      t.timestamps
    end
  end
end
