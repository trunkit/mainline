class Order < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_one :cart

  belongs_to :user
  belongs_to :shipping_address, class_name: "Address"

  def self.for_listing(user, params)
    return none unless user.parent_type == "Boutique"

    scope = case params[:type]
    when "supported"
      CartItem.where(supporting_boutique_id: user.parent_id)
    when "supplied"
      CartItem.where(supplying_boutique_id: user.parent_id)
    else
      CartItem.where("supporting_boutique_id = :id OR supplying_boutique_id = :id", id: user.parent_id)
    end

    scope = scope.joins(:cart).select("cart_items.id, carts.order_id")
    ids   = scope.map{|cart_item| cart_item.cart.order_id }.uniq

    where(id: ids).includes(cart: :cart_items).page(params[:page]).per(params[:per_page])
  end
end
