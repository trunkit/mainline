class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new {|controller| controller.current_user ? "application" : "home" }

  helper_method :referring_boutique

  private

  def subdomain_redirect
    case request.subdomain.split('.').last
    when "boutique"
      redirect_to("/boutique")
    when "brand"
      redirect_to("/brand")
    end
  end

  def referring_boutique
    @referring_boutique ||= Boutique.find(session[:referring_boutique_id]) if session[:referring_boutique_id]
  end
end
