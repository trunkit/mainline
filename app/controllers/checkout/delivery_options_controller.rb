class Checkout::DeliveryOptionsController < CatalogAbstractController
  force_ssl if: -> { Rails.env.production? }

  def show
  end

  def update
    current_cart.items.each do |ci|
      ci.update_attribute(:shipping_rate_id, params[:shipping_rates][ci.id.to_s])
    end

    redirect_to(checkout_payment_method_path)
  end
end
