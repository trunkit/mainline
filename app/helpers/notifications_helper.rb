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

  def notification_time_in_words(notification)
    to_time   = Time.now
    from_time = notification.created_at

    distance_in_minutes = ((to_time - from_time)/60.0).round
    distance_in_seconds = (to_time - from_time).round

    text = case distance_in_minutes
    when 0..1
      "#{distance_in_seconds}s"
    when 2...60
      "#{distance_in_minutes}m"
    when 60...1440
      "#{(distance_in_minutes / 60.0).round}h"
    when 1440...43200
      "#{(distance_in_minutes / 1440.0).round}d"
    else
      from_time.strftime("%m/%d/%Y")
    end

    content_tag(:span, text, class: "timestamp")
  end
end
