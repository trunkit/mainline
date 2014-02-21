class CartItemsController < CatalogAbstractController
  def create
    current_cart.items.create(cart_item_params)
    render(template: "carts/show")
  end

  def destroy
    current_cart.items.find(params[:id]).destroy
    render(template: "carts/show")
  end

  private

  def cart_item_params
    ciparams = params.require(:cart_item).permit(:item_id, :quantity)
    ciparams[:item_version] = Item.find(ciparams[:item_id]).version
    ciparams[:item_options] = params[:cart_item][:item_options]

    ciparams
  end
end
