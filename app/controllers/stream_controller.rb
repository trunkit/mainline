class StreamController < CatalogAbstractController
  def index
    @items = Item.for_stream(params)
  end

  def following
    @boutiques = Boutique.includes({ locations: :address })
  end
end
