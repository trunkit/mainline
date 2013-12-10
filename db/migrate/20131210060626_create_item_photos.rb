class CreateItemPhotos < ActiveRecord::Migration
  def change
    create_table :item_photos do |t|
      t.references :item
      t.string     :url

      t.timestamps
    end
  end
end
