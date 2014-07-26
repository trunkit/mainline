class CreateShippingEvents < ActiveRecord::Migration
  def change
    create_table :shipping_events do |t|
      t.string :event_id, :object, :mode, :description
      t.json   :previous_attributes
      t.json   :result
      t.timestamps
    end
  end
end
