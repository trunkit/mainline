class Boutique < ActiveRecord::Base
  include Elasticsearch::Model

  after_commit(on: [:create, :update]) { __elasticsearch__.index_document }
  after_commit(on: [:destroy])         { __elasticsearch__.remove_document }

  index_name    "trunkit"
  document_type "boutique"

  acts_as_paranoid
  has_paper_trail

  has_one  :address, as: :parent, dependent: :destroy
  has_many :users,   as: :parent, dependent: :destroy
  has_many :items,   dependent: :destroy

  before_validation :generate_short_code

  accepts_nested_attributes_for :address

  validates_presence_of   :name, :short_code
  validates_uniqueness_of :short_code
  validates_format_of     :short_code, with: /\A[a-zA-Z0-9\-_]+\Z/

  mount_uploader :cover_photo,  CoverPhotoUploader
  mount_uploader :stream_photo, StreamPhotoUploader

  delegate :street, :street2, :city, :state, :postal_code, :easypost_id, to: :address, allow_nil: true

  def self.search(q)
    body = {
      query: {
        query_string: {
          query: q,
          default_operator: "AND",
          phrase_slop: 2,
          fuzziness: 2
        }
      }
    }

    __elasticsearch__.search(body).records
  end

  def supplied_brands
    return @supplied_brands if @supplied_brands
    brand_ids = items.select(:brand_id).distinct.map(&:brand_id)
    @supplied_brands = Brand.find(brand_ids)
  end

  def supported_brands
    return @supported_brands if @supported_brands
    brand_ids = supported_items.select(:brand_id).distinct.map(&:brand_id)
    @supported_brands = Brand.find(brand_ids)
  end

  def add_follower(user)
    scope = Activity.for_subject(self).for_owner(user).where(action: "follow")
    scope.create if scope.count < 1
  end

  def remove_follower(user)
    activities = Activity.for_subject(self).for_owner(user).where(action: "follow")
    activities.each(&:destroy)
    true
  end

  def followers(reload = false)
    User.where(id: follower_ids(reload))
  end

  def follower_ids(reload = false)
    @follower_ids   = nil if reload
    @follower_ids ||= Activity.
      for_subject(self).
      where(action: "follow", owner_type: "User").
      select(:owner_id).map(&:owner_id)
  end

  def supported_items(reload = false)
    Item.where(id: supported_item_ids(reload))
  end

  def supported_item_ids(reload = false)
    @supported_item_ids   = nil if reload
    @supported_item_ids ||= Activity.
      for_owner(self).
      where(action: "support", subject_type: "Item").
      select(:subject_id).
      map(&:subject_id)
  end

  # TODO: Add fallback photos
  def primary_photo(size = nil)
    photo = stream_photo
    photo = photo.try(size) if size
    photo.try(:url)
  end

  def as_indexed_json(options={})
    json = as_json(options.merge({ root: false, except: [:data_sources] }))
    json[:brands]  = supported_brands.map(&:name)
    json[:address] = address.try(:as_indexed_json)
    json
  end

  def recipient
    return @recipient if defined?(@recipient)

    @recipient = recipient_id.present? ?
      Stripe::Recipient.retrieve(recipient_id) :
      Stripe::Recipient.new
  end

private
  def generate_short_code
    self.short_code = (0...6).map{ ('a'..'z').to_a[rand(26)] }.join if short_code.blank?
  end
end
