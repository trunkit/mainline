class Address < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  validates :parent, :street, :city, :state, :postal_code, presence: true

  before_save do
    self.easypost_id = easypost.id
  end

  def to_s
    street2 = "#{street2}\n" if street2.present?

    [street, street2, "\n", "#{city},", state, postal_code].compact.join(" ")
  end

private
  def easypost
    @easypost ||= EasyPost::Address.create({
      street1: street,
      street2: street2,
      city:    city,
      state:   state,
      zip:     postal_code,
      name:    parent.name
    })
  end
end
