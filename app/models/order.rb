class Order
  include Mongoid::Document

  embeds_many :order_items
end
