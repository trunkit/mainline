module NotificationsHelper
  def render_notification(notification)
    return if notification.owner.blank?

    if current_user.parent.items.map(&:id).include?(notification.subject_id) && notification.subject_type == "Item" && notification.action == "support"
      render("item_supported", notification: notification)
    elsif notification.subject_type == "Item" && notification.action == "purchased"
      render("item_purchased", notification: notification)
    elsif notification.subject_type == "Boutique" && notification.action == "follow"
      render("boutique_follow", notification: notification)
    end
  end
end
