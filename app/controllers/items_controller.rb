class ItemsController < CatalogAbstractController
  def index
    rel    = current_user.parent.items
    @items = params[:supported] ? rel.supported : rel.curated
    @items = @items.for_category(params[:category]) if params[:category]
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
    status = Favorite.toggle_for_user_and_item(current_user.id, params[:item_id])

    respond_to do |format|
      format.json { render(json: { favorite: status }) }
    end
  end
end
