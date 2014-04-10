class ChangeMeasurementsToDiscreteFields < ActiveRecord::Migration
  def change
    change_table :items do |t|
      t.decimal :model_height, :model_chest, :model_waist, :model_hips, precision: 5, scale: 2
      t.text    :model_size

      t.remove  :model_measurements
    end
  end
end
