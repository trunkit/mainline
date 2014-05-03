class Cart < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :shipping_address, class_name: "Address"
  has_many :items, class_name: "CartItem"

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

    scope = scope.joins(:cart).select("cart_items.cart_id")
    ids   = scope.map{|cart_item| cart_item.cart_id }.uniq

    where(id: ids).includes(:cart_items).page(params[:page]).per(params[:per_page])
  end

  def total_price
    items.to_a.sum(&:total_price)
  end
end
