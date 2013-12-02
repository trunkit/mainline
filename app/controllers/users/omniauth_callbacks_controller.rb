class Users::OmniauthCallbacksController < Devise::OmniAuthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to(new_user_registration_url)
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to(new_user_registration_url)
    end
  end
end
