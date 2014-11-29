class Admin::CustomerOrdersController < Admin::AbstractController
  before_filter do
    @boutiques = Boutique.order(:name)
    @items = Item.order(:name)
  end

  def index
    @customer_orders = CustomerOrder.order(:name)
  end

  def new
    @customer_order = CustomerOrder.new
  end

  def create
    @customer_order = CustomerOrder.create(customer_order_params)

    if @customer_order.errors.blank?
      redirect_to([:edit, :admin, @customer_order])
    else
      render(action: :new)
    end
  end

  def edit
    @customer_order = CustomerOrder.find(params[:id])
  end

  def update
    @customer_order = CustomerOrder.find(params[:id])

    params = {}
    if @customer_order.update_attributes(customer_order_params)
      redirect_to([:edit, :admin, :customer_order])
    else
      render(action: :edit)
    end
  end

  private
  def customer_order_params
    params.require(:customer_order).permit([:name, :order_number, :boutique_id, :customer_name, :fulfillment_status, :created_at, :shipping_label, :item])
  end
end