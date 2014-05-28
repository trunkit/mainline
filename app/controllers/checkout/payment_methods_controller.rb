class Checkout::PaymentMethodsController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  def show
  end

  def update
    session[:card_token] = params[:card_token]
    redirect_to(checkout_order_path)
  end
end
