class ItemsController < CatalogAbstractController
  before_filter only: [:new, :create, :edit, :update] do
    @brands               = Brand.order(:name)
    @boutiques            = Boutique.order(:name)
    @primary_categories   = Category.where(parent_id: nil).order(:name)
    @secondary_categories = Category.where.not(parent_id: nil).order(:name).group_by(&:parent_id)
  end

  def index
    boutique = current_user.parent
    @items = params[:supported] ? boutique.supported_items : boutique.items
    @items = @items.for_category(params[:category]) if params.key?(:category)
  end

  def show
    @item      = Item.includes(:photos).find(params[:id])
    @activity  = Activity.find(params[:activity_id]) if params[:activity_id]
    @cart_item = CartItem.new

    render(nothing: true, status: 404) unless @activity || current_user.parent_type.present?
  end

  def new
    @item = current_user.items.build
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to([:edit, @item])
    else
      render(action: :new)
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def update
    @item = current_user.items.find(params[:id])

    if @item.update_attributes(item_params)
      redirect_to([:edit, @item])
    else
      render(action: :edit)
    end
  end

  def destroy
    current_user.items.find(params[:id]).destroy
    redirect_to items_path
  end

  def support
    @item = Item.find(params[:id])
    @item.add_supporter(current_user.parent)
  end

  def unsupport
    @item = Item.find(params[:id])
    @item.remove_supporter(current_user.parent)
  end

private

  def item_params
    params.require(:item).permit([:name, :price, :description, :fit, :construction, :model_height, :model_chest, :model_hips, :model_waist, :model_size, :brand_id, :primary_category_id, :secondary_category_id]).tap do |whitelisted|
      whitelisted[:sizes] = params[:item][:sizes]
    end
  end
end
