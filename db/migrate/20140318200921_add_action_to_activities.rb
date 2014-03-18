class AddActionToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :action, :text, null: false
  end
end
