class Boutique < ActiveRecord::Base
  has_many :locations, as: :company
  has_many :users, as: :parent

  before_create :generate_short_code

  validates_uniqueness_of :short_code

private
  def generate_short_code
    self.short_code = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join if short_code.blank?
  end
end
