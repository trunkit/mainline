class NotificationsController < CatalogAbstractController
  def index
    @activities = Activity.for_notification_stream(current_user)
  end
end
