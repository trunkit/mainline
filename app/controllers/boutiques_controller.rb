class BoutiquesController < CatalogAbstractController
  skip_before_filter :authenticate_user!, :check_roles, only: [:search, :show]

  def search
    @boutiques = Boutique.search(params[:q])
  end

  def show
    @boutique = Boutique.includes(:items, :address).find(params[:id])

    activities = Activity.
      for_owner(@boutique).
      where(action: (current_user && current_user.parent.present?) ? ["support", "added"] : "support").
      where(subject_type: "Item")

    items = Item.find(activities.map(&:subject_id)).index_by(&:id)

    @activity_items = activities.map{|activity| [activity, items[activity.subject_id]] }
  end

  def follow
    @boutique = Boutique.find(params[:id])
    @boutique.add_follower(current_user)
  end

  def unfollow
    @boutique = Boutique.find(params[:id])
    @boutique.remove_follower(current_user)
  end
end
