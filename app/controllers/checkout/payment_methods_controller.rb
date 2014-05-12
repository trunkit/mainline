class Checkout::PaymentMethodsController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  def show
  end

  def update
  end
end
