class AddPackagingWidthAndPackagingHeightAndPackagingLengthToItems < ActiveRecord::Migration
  def change
    add_column(:items, :packaging_width, :decimal, precision: 9, scale: 2, default: 12)
    add_column(:items, :packaging_height, :decimal, precision: 9, scale: 2, default: 12)
    add_column(:items, :packaging_length, :decimal, precision: 9, scale: 2, default: 12)
  end
end
