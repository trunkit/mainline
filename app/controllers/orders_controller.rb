class OrdersController < CatalogAbstractController
  def index
    @orders = Order.for_listing(current_user, params)
  end
end
