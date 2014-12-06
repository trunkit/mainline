class ItemsController < CatalogAbstractController
  swagger_controller :item, "Product Stream"

  before_filter only: [:new, :create, :edit, :update] do
    @brands               = Brand.order(:name)
    @boutiques            = Boutique.order(:name)
    @primary_categories   = Category.where(parent_id: nil).order(:name)
    @secondary_categories = Category.where.not(parent_id: nil).order(:name).group_by(&:parent_id)
  end

  swagger_api :index do
    summary "Fetches all items that are either supplied or supported by a boutique"

    param :query, :supported, :boolean, :optional, "Boutique ID"
    param :query, :category, :integer, :optional, "Category ID"

    type :Item

    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity
  end

  def index
    boutique = current_user.parent

    @items = params[:supported].to_s =~ /^?(t|true)$/ ? boutique.supported_items : boutique.items
    @items = @items.for_category(params[:category]) if params.key?(:category)

    respond_to do |format|
      format.html
      format.json { render(json: @items) }
    end
  end

  def show
    @item      = Item.includes(:photos, :restock_notification_users).find(params[:id])
    @activity  = Activity.find(params[:activity_id]) if params[:activity_id]
    @cart_item = CartItem.new

    return render(nothing: true, status: 404) unless @activity || current_user.parent_type.present?

    respond_to do |format|
      format.html
      format.json { render(json: @item.to_json(methods: :photos)) }
    end
  end

  def new
    @item = current_user.items.build
  end

  swagger_api :create do
    summary "Add a supplied item for a boutique"

    param :body, :body, :string, :required, "Item"

    response :unauthorized
    response :not_acceptable
    response :unprocessable_entity
  end

  def create
    @item  = current_user.items.build(item_params)

    respond_to do |format|
      format.html do
        @item.save ? redirect_to([:edit, @item]) : render(action: :new)
      end

      format.json do
        @item.save ?
          render(json: @item.to_json(methods: :photos)) :
          render(json: @item.errors, status: 422)
      end
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def update
    @item = current_user.items.find(params[:id])

    if @item.update_attributes(item_params)
      # send email
      Notifier.item_added(@item, current_user).deliver
      respond_to do |format|
        format.html { redirect_to([:edit, @item]) }
        format.json { render(json: @item.to_json(methods: :photos)) }
      end
    else
      respond_to do |format|
        format.html { render(action: :new) }
        format.json { render(json: @item.errors, status: 422) }
      end
    end
  end

  def destroy
    current_user.items.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to(items_path) }
      format.json { render(nothing: true, status: 200) }
    end
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
    params.require(:item).permit([:name, :style, :price, :discount_amount, :description, :fit, :construction, :model_height, :model_chest, :model_hips, :model_waist, :model_size, :brand_id, :primary_category_id, :secondary_category_id, :list_on_trunksale]).tap do |whitelisted|
      whitelisted[:sizes] = params[:item][:sizes]
    end
  end

  swagger_model :Item do
    description "Item model"
    property :id, :integer, :required, "User ID"
    property :style_number, :string, :require, "Style Number"
    property :name, :string, :required, "Item Name"
    property :price, :number, :required, "Price"
    property :description, :string, :required, "Item Description"
    property :construction, :string, :optional, "Description of the item's construction"
  end
end
