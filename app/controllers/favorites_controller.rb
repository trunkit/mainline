class FavoritesController < CatalogAbstractController
  def index
    activities = current_user.favorite_item_activities
    items      = Item.find(activities.map(&:subject_id)).index_by(&:id)

    @activity_items = activities.map{|a| [a, items[a.subject_id]] }
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @status = current_user.toggle_favorite(@activity)
  end
end
