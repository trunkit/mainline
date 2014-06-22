class OrdersController < CatalogAbstractController
  def index
    @orders = Cart.boutique_orders_listing(current_user, params)
    @users  = User.unscoped.find(@orders.map(&:user_id)).index_by(&:id)
  end
end
