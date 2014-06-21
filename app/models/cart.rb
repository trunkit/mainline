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

    where(id: ids).where.not(transaction_id: nil).includes(:items).page(params[:page]).per(params[:per_page])
  end

  def capture_order!(card)
    charge = Stripe::Charge.create({
      amount:   (total_price * 100).to_i,
      currency: "usd",
      card:     card
    })

    saved = update_attributes(
      transaction_id: charge.id,
      captured_at:    Time.now
    )

    add_activity_entries if saved

    saved
  end

  def tax
    items.to_a.sum(&:tax)
  end

  def total_price
    items.to_a.sum(&:total_price)
  end

private
  def add_activity_entries
    items.each do |cart_item|
      Activity.for_subject(cart_item.item).for_owner(user).create({ action: 'purchased' })
    end
  end
end
