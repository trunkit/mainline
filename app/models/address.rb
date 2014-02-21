class Address < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  validates_presence_of :parent_id, :parent_type, :street, :city, :state, :postal_code

  def to_s
    [street, street2, "\n", city, state, postal_code].compact.join(" ")
  end
end
