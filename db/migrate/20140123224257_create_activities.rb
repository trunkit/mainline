class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :owner,   polymorphic: true, index: true
      t.references :subject, polymorphic: true, index: true

      t.timestamps
    end
  end
end
