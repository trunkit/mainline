class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout ->(controller) { return false if request.xhr? }

  helper_method :referring_boutique

  before_filter :subdomain_redirect, :track_referral_code
  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :masquerade_user
  before_filter :set_time_zone, if: :current_user

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
        redirect_to(boutique_path(b, subdomain: remainder))
      end
    end
  end

  def track_referral_code
    if params[:referral_code] =~ /br\-([\d]+)/
      session[:referring_boutique_id] = $1
    end
  end

  def referring_boutique
    @referring_boutique ||= Boutique.find(session[:referring_boutique_id]) if session[:referring_boutique_id]
  end

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end

  def masquerade_user
    @current_user = User.find(session[:masquerade_user]) if session[:masquerade_user].present?
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user.time_zone.present?
  end
end
