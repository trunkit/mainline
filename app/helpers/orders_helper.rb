module OrdersHelper
  def listing_order_date(user, cart)
    items = cart.items.where(supplying_boutique_id: user.parent_id)
    return if items.blank?

    if items.all?{|i| (i.completed_at.present? && !i.refundable?) || i.refund_ledger_entry_id.present? }
      last_item = items.max(&:updated_at)
      time      = last_item.refunded? ? last_item.refund_ledger_entry.created_at : last_item.completed_at

      "Date Completed: #{time.strftime('%m/%d/%Y')}" if time
    else
      "Date Ordered: #{cart.captured_at.strftime('%m/%d/%Y')}"
    end
  end

  def item_order_status_button(user, cart_item)
    if cart_item.cancellation_refund_id.present?
      link_to("Cancelled", "#", class: "btn btn-supplied disabled")
    elsif cart_item.refund_ledger_entry_id.present?
      link_to("Refunded", "#", target: "_blank", class: "btn disabled")
    elsif cart_item.refund_requested.present?
      link_to("Refund Requested", "#", target: "_blank", class: "btn")
    elsif cart_item.completed_at.present? && user.parent_id.present?
      link_to("Shipping Label", cart_item.shipping_label.postage_label.label_url, target: "_blank", class: "btn shipping-label")
    elsif cart_item.supplied?(current_user.parent_id)
      link_to("Pending", "#cart-item-complete-#{cart_item.id}", class: "btn fancybox")
    elsif user.parent_id.present?
      link_to("Curated", "#", class: "btn btn-supplied disabled")
    else
      link_to("Request Refund", "#", class: "btn btn-supplied")
    end
  end
end
