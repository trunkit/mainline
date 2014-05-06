class Checkout::ShippingAddressesController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  def index
    if current_user.addresses.blank?
      @address = current_user.addresses.build
      render("new")
    else
      render("index")
    end
  end

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.create(address_params)

    if @address.persisted?
      render("index")
    else
      render("new")
    end
  end

  def edit
    @address = current_user.addresses.find(params[:id])
    render("new")
  end

  def update
    @address = current_user.addresses.find(params[:id])
    @address.update_attributes(address_params)
    render("index")
  end

  def destroy
    current_user.addresses.find(params[:id]).destroy
    render("index")
  end

  def select
    address = current_user.addresses.find(params[:id])
    current_cart.shipping_address = address
    current_cart.save

    redirect_to(checkout_delivery_options_index_path)
  end

private
  def address_params
    params.require(:address).permit([:street, :street2, :city, :state, :postal_code])
  end
end
