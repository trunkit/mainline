class Checkout::OrdersController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  def show
    begin
      @token = Stripe::Token.retrieve(session[:card_token])
    rescue Stripe::InvalidRequestError
      redirect_to(checkout_payment_method_path)
    end
  end

  def update
  end
end
