class ItemsController < CatalogAbstractController
  def index
    boutique = current_user.parent
    @items = params[:supported] ? boutique.supported_items : boutique.items
    @items = @items.for_category(params[:category]) if params.key?(:category)
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

  def support
    @item = Item.find(params[:id])
    @item.add_supporter(current_user.parent)
  end

  def unsupport
    @item = Item.find(params[:id])
    @item.remove_supporter(current_user.parent)
  end
end
