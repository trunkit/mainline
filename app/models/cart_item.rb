class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  has_many :commissions

  validates :quantity, :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, presence: true
  validates :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, numericality: true

  belongs_to :supporting_boutique, class_name: "Boutique"
  belongs_to :supplying_boutique,  class_name: "Boutique"
  belongs_to :refund_ledger_entry, class_name: "LedgerEntry"

  @@shipping_options = [['UPS Ground', 'Ground'], ['UPS 3 Day Select', '3DaySelect'], ['UPS Second Day Air', '2ndDayAir'], ['UPS Next Day Air Saver', 'NextDayAirSaver']].freeze
  cattr_reader :shipping_options

  @@state_taxes = {'AL' => '4.0', 'AK' => '0', 'AZ' => '5.6', 'AR' => '6.5', 'CA' => '7.5', 'CO' => '2.9', 'CT' => '6.35', 'DE' => '0', 'FL' => '6.0', 'GA' => '4.0', 'HI' => '4.0', 'ID' => '6.0', 'IL' => '6.25', 'IN' => '7.0', 'IA' => '6.0', 'KS' => '6.15', 'KY' => '6.0', 'LA' => '4.0', 'ME' => '5.5', 'MD' => '6.0', 'MA' => '6.25', 'MI' => '6.0', 'MN' => '6.88', 'MO' => '7.0', 'MT' => '0.0', 'NE' => '5.5', 'NV' => '6.85', 'NH' => '0.0', 'NJ' => '7.0', 'NM' => '5.13', 'NY' => '4.0', 'NC' => '4.75', 'ND' => '5.0', 'OH' => '5.75', 'OK' => '4.5', 'OR' => '0.0', 'PA' => '6.0', 'RI' => '7.0', 'SC' => '6.0', 'SD' => '4.0', 'TN' => '7.0', 'TX' => '6.25', 'UT' => '5.95', 'VT' => '6.0', 'VA' => '5.3', 'WA' => '6.5', 'WV' => '6.0', 'WI' => '5.0', 'WY' => '4.0', 'DC' => '5.75' }.freeze
  cattr_reader :state_taxes

  before_save :build_parcel, :store_shipping_cost

  delegate :purchased?, to: :cart

  def item
    return @item if @item

    @item = Item.unscoped.find(item_id)

    if @item.version > item_version
      @item = @item.versions[item_version - 1].reify
    end

    @item
  end

  def latest_item
    Item.find(item_id)
  end

  def supplied?(boutique_id)
    boutique_id.to_i == supplying_boutique_id
  end

  def prorata_stripe_fee
    (total_price / cart.total_price) * cart.stripe_fee
  end

  def unit_price
    item.price
  end

  def subtotal_price
    quantity * unit_price
  end

  def subtotal_price_less_prorata_credit
    subtotal_price * cart.external_payment_percentage.round(9)
  end

  def subtotal_with_shipping
    subtotal_price + shipping
  end

  def tax
    if cart.shipping_address.try(:state) == item.boutique.state
      tax_rate = (BigDecimal.new(self.class.state_taxes[cart.shipping_address.state]) / 100)
      subtotal_price * tax_rate
    else
      0
    end
  end

  def total_price
    subtotal_price + shipping + tax
  end

  def shipping_rate
    if self[:shipping_rate_id]
      shipment.rates.detect{|r| r.id == self[:shipping_rate_id] }
    else
      best_rate
    end
  end

  alias_method :rate, :shipping_rate

  def rates
    @rates ||= shipping_options.map do |name, service|
      [name, rate_for_service(service)]
    end
  end

  def best_rate
    @best_rate ||= rates.map(&:last).sort_by{|r| r.rate.to_f }.first
  end

  def rate_for_service(service)
    shipment.rates.detect{|r| r.service == service }
  end

  def parcel
    return @parcel if @parcel

    @parcel = if parcel_id.blank?
      EasyPost::Parcel.create({
        width:  item.packaging_width,
        length: item.packaging_length,
        height: item.packaging_height,
        weight: (item.weight * 16) * quantity
      })
    else
      EasyPost::Parcel.retrieve(parcel_id)
    end
  end

  def shipment
    return @shipment if @shipment

    @shipment = if shipment_id.blank?
      shipment = EasyPost::Shipment.create({
        to_address:   { id: cart.shipping_address.easypost_id },
        from_address: { id: item.boutique.easypost_id },
        parcel:       { id: parcel_id }
      })

      update_column(:shipment_id, shipment.id)

      shipment
    else
      EasyPost::Shipment.retrieve(shipment_id)
    end
  end

  def shipping_label
    return unless purchased?

    if self[:shipping_label].blank?
      update_column(:shipping_label, shipment.buy(rate).to_hash)
    end

    EasyPost::PostageLabel.construct_from(self[:shipping_label])
  end

  def return_label
    return if !purchased? || cancellation_refund_id.blank?

    if self[:return_label].blank?
      shipment = EasyPost::Shipment.create({
        to_address:   { id: cart.shipping_address.easypost_id },
        from_address: { id: item.boutique.easypost_id },
        parcel:       { id: item.parcel_id },
        is_return:    true
      })

      valid_shipping_methods = shipping_options.map{|name, service| service }
      rates = shipment.rates.select{|r| valid_shipping_methods.include?(r.service) }
      rate  = rates.sort_by{|r| r.rate.to_f }.first

      update_columns(return_label: shipment.buy(rate).to_hash)
    end

    EasyPost::PostageLabel.construct_from(self[:return_label])
  end

  def complete!
    transaction do
      Commission.create_for_cart_item!(self)
      update_columns(completed_at: Time.now)
      shipping_label
    end

    true
  end

  def cancel!(message)
    charge = Stripe::Charge.retrieve(cart.transaction_id)
    refund = charge.refund(amount: (total_price * 100).to_i)
    update_attributes(cancellation_refund_id: refund.id)

    Notifier.cart_item_cancellation(id, message).deliver

    true
  end

  def shipped?
    shipped_at.present?
  end

  def delivered?
    delivered_at.present?
  end

  def refundable?
    false
  end

  def refunded?
    refund_ledger_entry_id.present?
  end

  def request_refund
    return if !purchased? || completed_at.blank? || refund_requested? || !refundable?

    update_attributes(refund_requested: true)
    Notifier.refund_requested(id).deliver

    true
  end

  def refund!(user)
    return if !purchased? || !refund_requested?

    transaction do
      self.lock!

      user = User.unscoped.lock.find(cart.user_id)
      le   = user.ledger_entries.create!({
        whodunnit:   self,
        value:       -subtotal_price,
        description: "Credit refund on #{item.name}. Accepted by #{user.name}"
      })

      Commission.refund_for_cart_item!(self)

      user.update_account_balance!

      self.update_attributes!({ refund_ledger_entry_id: le.id })
    end

    true
  end

private
  def build_parcel
    return if cart.purchased? || (changes.keys & ['quantity', 'item_version']).blank?

    self[:shipment_id] = nil
    self[:parcel_id]   = nil
    self[:parcel_id]   = parcel.id
  end

  def store_shipping_cost
    return unless self[:shipping_rate_id].present?
    self.shipping = BigDecimal.new(shipping_rate.rate.to_s.gsub(/[^0-9\.]/, ''))
  end
end
