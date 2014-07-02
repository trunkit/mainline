class OrdersController < CatalogAbstractController
  def index
    if current_user.parent_id.blank?
      @orders = Cart.where(user_id: current_user.id).ordered.includes(:user)

      render(action: "index_shopper")
    else
      @orders      = Cart.boutique_orders_listing(current_user, params)
      @users       = User.unscoped.find(@orders.map(&:user_id)).index_by(&:id)
      @commissions = Commission.collectable_for(current_user)

      render(action: "index_boutique")
    end
  end
end
