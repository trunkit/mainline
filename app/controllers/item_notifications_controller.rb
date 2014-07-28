class ItemNotificationsController < CatalogAbstractController
  def create
    @item = Item.includes(:restock_notification_users, :boutique).find(params[:item_id])
    @item.restock_notification_users << current_user unless @item.restock_notification_users.include?(current_user)
  end
end
