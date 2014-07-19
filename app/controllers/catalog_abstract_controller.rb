class CatalogAbstractController < ApplicationController
  before_filter :authenticate_user!, :check_roles, :validate_boutique

  helper_method :current_cart

  private

  def current_cart(reload = false)
    return @current_cart if @current_cart || reload

    if session[:cart_id]
      @current_cart = current_user.carts.includes(:items).find(session[:cart_id])
    else
      @current_cart     = current_user.carts.create
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end

  def check_roles
    redirect_to(:admin) if current_user.has_any_role?(:system)
  end

  def validate_boutique
    redirect_to(payments_company_path) if current_user.try(:parent) && current_user.parent.recipient_id.blank?
  end

  def verify_shopper_has_cart_items
    redirect_to(stream_path) unless session[:cart_id] && current_cart.items.present?
  end
end