class CreateBoutiques < ActiveRecord::Migration
  def change
    create_table :boutiques do |t|
      t.string :name
    end
  end
end
