class Admin::UsersController < Admin::AbstractController
  before_filter :validate_not_current_user, only: [:destroy, :masquerade]

  def index
    @users = User.order("created_at DESC")
  end

  def new
    @user      = User.new(params[:user].present? ? user_params : {})
    @boutiques = Boutique.order("name DESC").map{|b| [b.name, b.id] }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to([:edit, :admin, @user])
    else
      @boutiques = Boutique.order("name DESC").map{|b| [b.name, b.id] }
      render(action: :new)
    end
  end

  def edit
    @user      = user
    @boutiques = Boutique.order("name DESC").map{|b| [b.name, b.id] }
  end

  def update
    user.update_attributes!(user_params)
    redirect_to([:edit, :admin, user])
  end

  def destroy
    user.destroy
    redirect_to(action: :index)
  end

  def masquerade
    session[:masquerade_user] = @user.id
    redirect_to(root_url)
  end

  private

  def user_params
    attrs  = [:first_name, :last_name, :email, :gender, :time_zone, :photo, :parent_id, :roles]
    attrs += [:password, :password_confirmation] if params[:user].try(:password).try(:present?)

    params.require(:user).permit(attrs).tap do |whitelisted|
      whitelisted[:parent_type] = (params[:user][:parent_id].present? ? "Boutique" : nil)
    end
  end

  def user
    @user ||= User.find(params[:id] || params[:user_id])
  end

  def validate_not_current_user
    redirect_to(action: :index) if user == current_user
  end
end
