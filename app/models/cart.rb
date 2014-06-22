class Cart < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :shipping_address, class_name: "Address"
  has_many :items, class_name: "CartItem"

  def self.boutique_orders_listing(user, params)
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

    where(id: ids).where("transaction_id IS NOT NULL OR ledger_entry_id IS NOT NULL").includes(:items).order(captured_at: :desc).page(params[:page]).per(params[:per_page])
  end

  def capture_order!(card)
    transaction do
      begin
        user.lock!

        attrs = { captured_at: Time.now }

        if total_price_after_credit > 0
          charge = Stripe::Charge.create({
            amount:   (total_price_after_credit * 100).to_i,
            currency: "usd",
            card:     card
          })

          attrs[:transaction_id] = charge.id
        end

        if user.account_balance < 0
          value = total_price_after_credit > 0 ? user.account_balance : total_price

          le = user.ledger_entries.create!({
            description: "Purchase using Trunkit Credit.",
            value: value,
            whodunnit: self
          })

          attrs[:ledger_entry_id] = le.id
        end

        update_attributes!(attrs)
        add_activity_entries

      rescue => e
        Stripe::Charge.retrieve(attrs[:transaction_id]).refund if attrs[:transaction_id]
        raise e
      end
    end

    true
  end

  def tax
    items.to_a.sum(&:tax)
  end

  def subtotal_price
    items.to_a.sum(&:subtotal_price)
  end

  def subtotal_price_after_credit
    price = subtotal_price + user.account_balance
    price > 0 ? price : 0
  end

  def total_price
    items.to_a.sum(&:total_price)
  end

  def total_price_after_credit
    price = total_price + user.account_balance
    price > 0 ? price : 0
  end

  def purchased?
    transaction_id.present? || ledger_entry_id.present?
  end

private
  def add_activity_entries
    items.each do |cart_item|
      Activity.for_subject(cart_item.item).for_owner(user).create({ action: 'purchased' })
    end
  end
end
