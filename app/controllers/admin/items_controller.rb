class Admin::ItemsController < Admin::AbstractController
  def index
    @items = Item.includes(:boutique)
  end

  def new
    @item      = Item.new
    @brands = Brand.order(:name)
    @boutiques = Boutique.order(:name)
  end

  def create
    @item = Item.create(item_params)

    if @item.errors.blank?
      redirect_to([:edit, :admin, @item])
    else
      @brands = Brand.order(:name)
      @boutiques = Boutique.order(:name)
      render(action: :new)
    end
  end

  def edit
    @item      = Item.find(params[:id])
    @brands    = Brand.order(:name)
    @boutiques = Boutique.order(:name)
  end

  def update
    @item = Item.find(params[:id])

    if @item.errors.blank?
      redirect_to([:edit, :admin, @item])
    else
      @brands = Brand.order(:name)
      @boutiques = Boutique.order(:name)
    end
  end

  def destroy
    Item.destroy(params[:id])
    redirect_to(action: :index)
  end

  private

  def item_params
    params.require(:item).permit([:name, :price, :description, :fit, :construction, :model_measurements, :brand_id, :boutique_id])
  end
end
