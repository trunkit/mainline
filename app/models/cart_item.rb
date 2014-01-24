class CartItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :cart

  validates :quantity, :item_id, :item_version, :cart_id, presence: true
  validates :item_id, :item_version, :cart_id, numericality: true

  before_save :validate_item_options

  private

  # TODO: Add item option validations
  def validate_item_options
  end
end
