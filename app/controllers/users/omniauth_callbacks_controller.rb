class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
