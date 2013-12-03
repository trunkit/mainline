class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new {|controller| controller.current_user ? "application" : "home" }

  helper_method :referring_boutique

  before_filter :subdomain_redirect
  before_filter :configure_devise_params, if: :devise_controller?

  private

  def subdomain_redirect
    name, remainder = request.subdomain.split('.', 2)

    case name
    when "boutique"
      redirect_to("/boutique")
    when "brand"
      redirect_to("/brand")
    else
      if b = Boutique.where(short_code: name).first
        session[:referring_boutique_id] = b.id
        redirect_to(url_for(subdomain: remainder))
      end
    end
  end

  def referring_boutique
    @referring_boutique ||= Boutique.find(session[:referring_boutique_id]) if session[:referring_boutique_id]
  end

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end
end
