class AddReferencesDesignerToItem < ActiveRecord::Migration
  def change
    add_reference :items, :designer
  end
end
