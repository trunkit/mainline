class NotificationsController < CatalogAbstractController
  def index
    @activities = Activity.for_notification_stream(current_user)
    current_user.touch(:last_viewed_notifications_at)
  end
end
