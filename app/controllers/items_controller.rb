class ItemsController < CatalogAbstractController
  def show
    @item      = Item.includes(:options, :photos).find(params[:id])
    @cart_item = CartItem.new
  end

  def favorite
    status = Favorite.toggle_for_user_and_item(current_user.id, params[:item_id])

    respond_to do |format|
      format.json { render(json: { favorite: status }) }
    end
  end
end
