class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code

      t.references :parent

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
