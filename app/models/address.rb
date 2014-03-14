class Address < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  validates :parent, :street, :city, :state, :postal_code, presence: true

  def to_s
    street2 = "#{street2}\n" if street2.present?

    [street, street2, "\n", "#{city},", state, postal_code].compact.join(" ")
  end
end
