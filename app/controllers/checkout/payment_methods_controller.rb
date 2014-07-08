class Checkout::PaymentMethodsController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  before_filter :verify_shopper_has_cart_items

  def show
    redirect_to(checkout_order_path) unless current_cart.total_price_after_credit > 0
  end

  def update
    session[:card_token] = params[:card_token]
    redirect_to(checkout_order_path)
  end
end
