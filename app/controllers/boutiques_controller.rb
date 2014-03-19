class BoutiquesController < CatalogAbstractController
  def redirect
    if b = Boutique.where(short_code: params[:short_code].strip).first
      session[:referring_boutique_id] = b.id
    end

    redirect_to(root_path)
  end

  def show
    @boutique = Boutique.includes(:items, :primary_location).find(params[:id])
  end

  def follow
    Boutique.find(params[:id]).add_follower(current_user)
  end

  def unfollow
    Boutique.find(params[:id]).remove_follower(current_user)
  end
end
