class Checkout::OrdersController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  before_filter do
    if current_cart.total_price_after_credit > 0
      begin
        @token = Stripe::Token.retrieve(session[:card_token])
      rescue Stripe::InvalidRequestError
        redirect_to(checkout_payment_method_path)
      end
    end
  end

  def show
  end

  def update
    current_cart.capture_order!(session[:card_token])
    session[:cart_id] = nil
  end
end
