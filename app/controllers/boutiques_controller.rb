class BoutiquesController < CatalogAbstractController
  def redirect
    if b = Boutique.where(short_code: params[:short_code].strip).first
      session[:referring_boutique_id] = b.id
    end

    redirect_to(root_path)
  end

  def show
    @boutique   = Boutique.includes(:items, :primary_location).find(params[:id])

    activities = Activity.
      for_owner(@boutique).
      where(action: current_user.parent.present? ? ["support", "added"] : "support").
      where(subject_type: "Item")

    items = Item.find(activities.map(&:subject_id)).index_by(&:id)

    @activity_items = activities.map{|activity| [activity, items[activity.subject_id]] }
  end

  def follow
    Boutique.find(params[:id]).add_follower(current_user)
  end

  def unfollow
    Boutique.find(params[:id]).remove_follower(current_user)
  end
end
