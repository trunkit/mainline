class UsersController < CatalogAbstractController
  def update
    current_user.update_attributes(user_params)
    redirect_to(settings_user_path)
  end

  private
  def user_params
    attrs  = [:first_name, :last_name, :email, :gender, :time_zone, :photo]
    attrs += [:password, :password_confirmation] if params[:user].try(:password).try(:present?)

    params.require(:user).permit(attrs)
  end
end
