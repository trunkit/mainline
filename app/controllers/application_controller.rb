class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new {|controller| controller.current_user ? "application" : "home" }

  private

  def subdomain_redirect
    case request.subdomain.split('.').last
    when "boutique"
      redirect_to("/boutique")
    when "brand"
      redirect_to("/brand")
    end
  end
end
