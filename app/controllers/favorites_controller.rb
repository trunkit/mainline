class FavoritesController < CatalogAbstractController
  def index
    @items_by_boutique = current_user.favorite_items.includes(boutique: { locations: :address }).group_by(&:boutique)
  end
end
