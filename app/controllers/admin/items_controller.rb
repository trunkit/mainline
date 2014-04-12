class Admin::ItemsController < Admin::AbstractController
  before_filter do
    @brands = Brand.order(:name)
    @boutiques = Boutique.order(:name)
    @categories = Category.order(:name)
  end

  def index
    @items = Item.includes(:boutique)
  end

  def new
    @item = Item.new
  end

  def create
    @item            = Item.create(item_params)
    @item.categories = Category.find(category_ids)

    if @item.errors.blank?
      redirect_to([:edit, :admin, @item])
    else
      render(action: :new)
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item            = Item.find(params[:id])
    @item.categories = Category.find(category_ids)

    if @item.update_attributes(item_params)
      redirect_to([:edit, :admin, @item])
    else
      render(action: :edit)
    end
  end

  def destroy
    Item.destroy(params[:id])
    redirect_to(action: :index)
  end

  private

  def item_params
    params.require(:item).permit([:name, :price, :description, :fit, :construction, :model_height, :model_chest, :model_hips, :model_waist, :model_size, :brand_id, :boutique_id])
  end

  def category_ids
    Array.wrap(params[:item].try(:[], :category_ids)).reject(&:blank?)
  end
end
