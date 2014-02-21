class DiscoverController < CatalogAbstractController
  def new
  end

  def create
    @items = Item.discover(params)
  end
end
