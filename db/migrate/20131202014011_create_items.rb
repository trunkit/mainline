class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string  :name
      t.decimal :price

      t.text :description
      t.text :fit
      t.text :construction
      t.text :model_measurements

      t.references :boutique

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
