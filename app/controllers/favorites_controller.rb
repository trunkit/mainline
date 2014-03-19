class FavoritesController < CatalogAbstractController
  def index
    @items_by_boutique = current_user.favorite_items.includes(:brand, :photos, boutique: { locations: :address }).group_by(&:boutique)
  end
end
