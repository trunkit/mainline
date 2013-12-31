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
end
