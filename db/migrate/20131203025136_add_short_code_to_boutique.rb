class AddShortCodeToBoutique < ActiveRecord::Migration
  def change
    add_column :boutiques, :short_code, :string, null: false
    add_index  :boutiques, :short_code, unique: true
  end
end
