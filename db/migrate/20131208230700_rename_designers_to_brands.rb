class RenameDesignersToBrands < ActiveRecord::Migration
  def change
    rename_table :designers, :brands
  end
end
