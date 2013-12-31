class FavoritesController < CatalogAbstractController
  def index
    @items_by_boutique = Item.includes(boutique: { locations: :address }).group_by(&:boutique)
  end
end
