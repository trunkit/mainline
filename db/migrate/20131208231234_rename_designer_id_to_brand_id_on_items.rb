class RenameDesignerIdToBrandIdOnItems < ActiveRecord::Migration
  def change
    rename_column :items, :designer_id, :brand_id
  end
end
