class Boutique < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :locations, as: :company
  has_many :users,     as: :parent
  has_many :items

  before_create :generate_short_code

  validates_presence_of   :name, :short_code
  validates_uniqueness_of :short_code
  validates_format_of     :short_code, with: /\A[a-zA-Z0-9\-_]+\Z/

private
  def generate_short_code
    self.short_code = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join if short_code.blank?
  end
end
