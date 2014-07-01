class AddLastViewedNotificationsAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_viewed_notifications_at, :datetime
  end
end
