class AddCompanyReferenceToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :company, index: true, polymorphic: true
  end
end
