class CategoriesController < CatalogAbstractController
  def index
    @categories = Category.all

    respond_to do |format|
      format.json { render(json: @categories) }
    end
  end
end
