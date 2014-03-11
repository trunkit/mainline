class Boutique < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :locations, as: :company, dependent: :destroy
  has_many :users,     as: :parent,  dependent: :destroy
  has_many :top_items, class_name: "Item", limit: 2
  has_many :items,     dependent: :destroy do
    def curated
      where(parent_id: nil)
    end

    def supported
      where.not(parent_id: nil)
    end

    def top
      limit(2)
    end
  end

  has_one  :primary_location, -> { where(primary: true) }, class_name: "Location", as: :company

  before_create :generate_short_code

  validates_presence_of   :name, :short_code
  validates_uniqueness_of :short_code
  validates_format_of     :short_code, with: /\A[a-zA-Z0-9\-_]+\Z/

  delegate :street, :street2, :city, :state, :postal_code, :stream_photo, :cover_photo, to: :primary_location, allow_nil: true

  def self.discover(params)
  end

  # TODO: Add fallback photos
  def primary_photo(size = nil)
    if primary_location
      p = primary_location.stream_photo
      p ? p.stream.url : nil
    else
    end
  end

private
  def generate_short_code
    self.short_code = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join if short_code.blank?
  end
end
