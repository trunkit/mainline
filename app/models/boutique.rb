class Boutique < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :locations, as: :company, dependent: :destroy
  has_many :users,     as: :parent,  dependent: :destroy
  has_many :items, 		 dependent: :destroy

  before_create :generate_short_code

  validates_presence_of   :name, :short_code
  validates_uniqueness_of :short_code
  validates_format_of     :short_code, with: /\A[a-zA-Z0-9\-_]+\Z/

	def primary_location
		locations.where(primary: true).first
	end

private
  def generate_short_code
    self.short_code = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join if short_code.blank?
  end
end
