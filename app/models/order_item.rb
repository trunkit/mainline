class OrderItem
  include Mongoid::Document

  embedded_in :order
end
