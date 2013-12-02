class Cart < ActiveRecord::Base
  has_many :items, class_name: "CartItem"
  belongs_to :order
end
