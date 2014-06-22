module OrdersHelper
  def item_order_status_button(cart_item)
    if cart_item.cancellation_refund_id.present?
      link_to("Cancelled", "#", class: "btn btn-supplied disabled")
    elsif cart_item.completed_at.present?
      link_to("Shipping Label", "#", target: "_blank", class: "btn")
    elsif cart_item.supplied?(current_user.parent_id)
      link_to("Complete", "#cart-item-complete-#{cart_item.id}", class: "btn fancybox")
    else
      link_to("Supported!", "#", class: "btn btn-supplied")
    end
  end
end
