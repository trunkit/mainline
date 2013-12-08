class Cart < ActiveRecord::Base
  acts_as_paranoid

  has_many :items, class_name: "CartItem"
  belongs_to :order
end
