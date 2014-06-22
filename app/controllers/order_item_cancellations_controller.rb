class OrderItemCancellationsController < CatalogAbstractController
  before_filter do
    @cart_item = CartItem.where(supplying_boutique_id: current_user.parent_id).find(params[:id])
  end

  def new
  end

  def create
    @cart_item.cancel!(params[:message])
    redirect_to(orders_path)
  end
end
