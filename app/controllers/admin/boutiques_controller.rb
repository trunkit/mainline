class Admin::BoutiquesController < Admin::AbstractController
  def index
    @boutiques = Boutique.order(:name)
  end

  def new
    @boutique = Boutique.new
  end

  def create
    @boutique = Boutique.create(boutique_params)

    if @boutique.errors.blank?
      redirect_to([:edit, :admin, @boutique])
    else
      render(action: :new)
    end
  end

  def edit
    @boutique = Boutique.find(params[:id])
  end

  def update
    @boutique = Boutique.find(params[:id])

    if @boutique.update_attributes(boutique_params)
      redirect_to([:edit, :admin, :boutique])
    else
      render(action: :edit)
    end
  end

  def destroy
    Boutique.destroy(params[:id])
    redirect_to(action: :index)
  end

private
  def boutique_params
    params.require(:boutique).permit([:name, :short_code, :stream_photo, :cover_photo])
  end
end
