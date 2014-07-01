class OrdersController < CatalogAbstractController
  before_filter do
    redirect_to(stream_path) unless current_user.parent_id.present?
  end

  def index
    @orders      = Cart.boutique_orders_listing(current_user, params)
    @users       = User.unscoped.find(@orders.map(&:user_id)).index_by(&:id)
    @commissions = Commission.collectable_for(current_user)
  end
end
