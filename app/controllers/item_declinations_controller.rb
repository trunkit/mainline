class ItemDeclinationsController < CatalogAbstractController
  before_filter do
    @item = Item.where(boutique_id: current_user.parent_id).find(params[:item_id])
  end

  def index
  end

  def update
    @item.decline_boutique(params[:id])
    render(action: :index)
  end
end
