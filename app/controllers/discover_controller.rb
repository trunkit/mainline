class DiscoverController < CatalogAbstractController
  def new
  end

  def create
    @items_by_boutique_id = Item.discover(params).results.group_by(&:boutique_id)
    @boutiques            = Boutique.find(@items_by_boutique_id.keys).index_by(&:id)
  end
end
