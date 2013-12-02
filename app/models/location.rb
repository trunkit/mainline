class Location < ActiveRecord::Base
  belongs_to :company, polymorphic: true
  has_one    :address, as: :parent
end
