class AddDeclinedBoutiqueIdsToItems < ActiveRecord::Migration
  def change
    add_column :items, :declined_boutique_ids, :integer, array: true
  end
end
