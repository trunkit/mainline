class Cart < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :shipping_address, class_name: "Address"
  has_many :items, class_name: "CartItem"

  belongs_to :ledger_entry

  def self.ordered
    where("transaction_id IS NOT NULL OR ledger_entry_id IS NOT NULL")
  end

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

    where(id: ids).ordered.includes(:items).order(captured_at: :desc).page(params[:page]).per(params[:per_page])
  end

  def verify_quantities!
    removed = []
    changed = []

    verify_latest_data!.each do |id|
      ci    = items(true).find(id)
      count = ci.latest_item.sizes[ci.size]

      if count == 0 || count.nil?
        ci.destroy
        removed << ci.id
      elsif ci.quantity > count
        ci.quantity = count
        ci.save

        changed << ci.id
      end
    end

    { removed: removed, changed: changed }
  end

  def verify_latest_data!(save = false)
    changed = []

    items = Item.where(id: self.items.map(&:item_id)).includes(:versions)
    items.each do |item|
      ci = self.items(true).detect{|ci| ci.item_id == item.id }

      changed << ci.id if item.version > ci.item_version
      ci.update_attribute(:item_version, item.version) if save && ci.changed?
    end

    changed
  end

  def capture_order!(card)
    transaction do
      begin
        user.lock!

        items       = Item.where(id: self.items.map(&:item_id)).lock
        qty_changes = verify_quantities!

        raise ActiveRecord::Rollback if qty_changes.values.flatten.present?

        self.items.each do |ci|
          i = items.detect{|i| i.id == ci.item_id }

          i.sizes_will_change!
          i.sizes[ci.size] -= ci.quantity
          i.save
        end

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
          value = total_price_after_credit > 0 ? user.account_balance.abs : total_price

          le = user.ledger_entries.create!({
            description: "Purchase using Trunkit Credit.",
            value: value,
            whodunnit: self
          })

          attrs[:ledger_entry_id] = le.id

          user.update_account_balance!
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

  def charge
    return if transaction_id.nil?
    @charge ||= Stripe::Charge.retrieve(transaction_id)
  end

  def charge_amount
    @charge_amt ||= (BigDecimal.new(charge.amount.to_s, 9) / BigDecimal.new("100", 9))
  end

  def credit_amount
    @credit_amt ||= ledger_entry.value
  end

  def stripe_fee
    charge_amount * BigDecimal.new("0.029", 9) + BigDecimal.new("0.30", 9)
  end

  def external_payment_percentage
    return BigDecimal.new("0", 9) if transaction_id.nil?
    return BigDecimal.new("1", 9) if ledger_entry_id.nil?

    ((charge_amount / (charge_amount + credit_amount))).round(9)
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
