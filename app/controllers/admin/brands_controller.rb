class Admin::BrandsController < Admin::AbstractController
  def index
    @brands = Brand.order(:name)

    respond_to do |format|
      format.html
      format.json { render(json: @brands) }
    end
  end

  def create
    brand = Brand.create(brand_params)

    respond_to do |format|
      format.html { redirect_to([:edit, :admin, brand]) }
      format.json { render(json: brand) }
    end
  end

  private

  def brand_params
    params.require(:brand).permit([:name])
  end
end
