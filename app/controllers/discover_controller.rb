class DiscoverController < CatalogAbstractController
  def new
  end

  def create
    @items_by_boutique_id = Item.discover(current_user, params).group_by{|i| i.first.owner_id }
    @boutiques            = Boutique.find(@items_by_boutique_id.keys).index_by(&:id)

    render("no_results") if @items_by_boutique_id.blank?
  end
end
