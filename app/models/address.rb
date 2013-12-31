class Address < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  def to_s
    [street, street2, "\n", city, state, postal_code].compact.join(" ")
  end
end
