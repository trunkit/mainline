class CartItemsController < CatalogAbstractController
  def create
    item = Item.find(cart_item_params[:item_id])

    ci = current_cart.items.build(cart_item_params)

    ci.item_version          = item.version
    ci.supplying_boutique_id = item.boutique_id

    ci.save!

    render(template: "carts/show")
  end

  def update
    current_cart.items.find(params[:id]).update_attribute(:quantity, params[:quantity])
    render(template: "carts/show")
  end

  def destroy
    current_cart.items.find(params[:id]).destroy
    render(template: "carts/show")
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :supporting_boutique_id, :quantity, :size)
  end
end
