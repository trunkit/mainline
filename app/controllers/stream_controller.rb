class StreamController < CatalogAbstractController
  def index
    @items = Item.all
  end
end
