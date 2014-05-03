class OrdersController < CatalogAbstractController
  def index
    @orders = Cart.for_listing(current_user, params)
  end
end
