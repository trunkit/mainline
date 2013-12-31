class ItemsController < CatalogAbstractController
  def show
    @item      = Item.includes(:options, :photos).find(params[:id])
    @cart_item = CartItem.new
  end
end
