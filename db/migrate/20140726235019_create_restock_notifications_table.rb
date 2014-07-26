class CreateRestockNotificationsTable < ActiveRecord::Migration
  def change
    create_table :restock_notifications, id: false do |t|
      t.integer :item_id, :user_id
    end
  end
end
