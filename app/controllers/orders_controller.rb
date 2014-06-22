class OrdersController < CatalogAbstractController
  def index
    @orders = Cart.boutique_orders_listing(current_user, params)
  end
end
