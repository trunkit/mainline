class Order < ActiveRecord::Base
  has_one :cart
  belongs_to :user
end
