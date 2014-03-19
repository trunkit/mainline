class Boutique < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_many :locations, as: :company, dependent: :destroy
  has_many :users,     as: :parent,  dependent: :destroy
  has_many :items,     dependent: :destroy do
    def top
      limit(2)
    end
  end

  has_one  :primary_location, -> { where(primary: true) }, class_name: "Location", as: :company

  before_validation :generate_short_code

  validates_presence_of   :name, :short_code
  validates_uniqueness_of :short_code
  validates_format_of     :short_code, with: /\A[a-zA-Z0-9\-_]+\Z/

  delegate :street, :street2, :city, :state, :postal_code, :stream_photo, :cover_photo, to: :primary_location, allow_nil: true

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
