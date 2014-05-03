class AddEasypostIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :easypost_id, :text
  end
end
