class Admin::ItemsController < Admin::AbstractController
  before_filter do
    @brands               = Brand.order(:name)
    @boutiques            = Boutique.order(:name)
    @primary_categories   = Category.roots.order(:name)
    @secondary_categories = Category.where.not(parent_id: nil).order(:name).group_by(&:parent_id)
  end

  def index
    @items = Item.includes(:boutique)
  end

  def pending_approval
    @items = Item.includes(:boutique).where(approved: false)
    render(action: :index)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      @item.grant_approval!
      redirect_to([:edit, :admin, @item])
    else
      render(action: :new)
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(item_params)
      redirect_to([:edit, :admin, @item])
    else
      render(action: :edit)
    end
  end

  def approve
    Item.find(params[:id]).grant_approval!
    redirect_to([:admin, :items])
  end

  def unapprove
    Item.find(params[:id]).revoke_approval!
    redirect_to([:pending_approval, :admin, :items])
  end

  def destroy
    Item.destroy(params[:id])
    redirect_to(action: :index)
  end

  private

  def item_params
    params.require(:item).permit([:name, :price, :description, :fit, :construction, :model_height, :model_chest, :model_hips, :model_waist, :model_size, :brand_id, :boutique_id, :primary_category_id, :secondary_category_id])
  end
end
