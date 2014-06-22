class OrderItemsController < CatalogAbstractController
  before_filter do
    @cart_item = CartItem.where(supplying_boutique_id: current_user.parent_id).find(params[:id])
  end

  def complete
    @cart_item.complete!
    redirect_to(orders_path)
  end
end
