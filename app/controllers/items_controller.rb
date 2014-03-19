class ItemsController < CatalogAbstractController
  def index
    boutique = current_user.parent
    @items = params[:supported] ? boutique.supported_items : boutique.items
  end

  def show
    @item      = Item.includes(:options, :photos).find(params[:id])
    @cart_item = CartItem.new
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def favorite
    item   = Item.find(params[:item_id])
    status = item.toggle_favorite(current_user)

    respond_to do |format|
      format.json { render(json: { favorite: status }) }
    end
  end

  def support
    Item.find(params[:id]).add_supporter(current_user.parent)
  end

  def unsupport
    Item.find(params[:id]).remove_supporter(current_user.parent)
  end
end
