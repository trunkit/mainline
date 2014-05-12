class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, presence: true
  validates :item_id, :item_version, :cart_id, :supporting_boutique_id, :supplying_boutique_id, numericality: true

  belongs_to :supporting_boutique, class_name: "Boutique"
  belongs_to :supplying_boutique, class_name: "Boutique"

  @@shipping_options = [['UPS Ground', 'Ground'], ['UPS 3 Day Select', '3DaySelect'], ['UPS Second Day Air', '2ndDayAir'], ['UPS Next Day Air Saver', 'NextDayAirSaver']].freeze
  cattr_reader :shipping_options

  before_save :store_shipping_cost

  def item
    return @item if @item

    @item = Item.find(item_id)

    if @item.version > item_version
      @item = @item.versions[item_version - 1].reify
    end

    @item
  end

  def unit_price
    item.price
  end

  def subtotal_price
    quantity * unit_price
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

  def shipment
    return @shipment if @shipment

    @shipment = if shipment_id.blank?
      shipment = EasyPost::Shipment.create({
        to_address:   { id: cart.shipping_address.easypost_id },
        from_address: { id: item.boutique.location.easypost_id },
        parcel:       { id: item.parcel_id }
      })

      update_column(:shipment_id, shipment.id)

      shipment
    else
      EasyPost::Shipment.retrieve(shipment_id)
    end
  end

private
  def store_shipping_cost
    return unless self[:shipping_rate_id].present?
    self.shipping = BigDecimal.new(shipping_rate.rate.to_s.gsub(/[^0-9\.]/, ''))
  end
end
