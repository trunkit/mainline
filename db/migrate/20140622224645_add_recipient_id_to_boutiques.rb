class AddRecipientIdToBoutiques < ActiveRecord::Migration
  def change
    add_column :boutiques, :recipient_id, :text
  end
end
