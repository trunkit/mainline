class ChangeDescriptionToTextOnBoutiques < ActiveRecord::Migration
  def change
    change_column(:boutiques, :description, :text)
  end
end
