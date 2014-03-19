class User < ActiveRecord::Base
  include RoleModel
  roles :system, :admin

  has_paper_trail
  acts_as_paranoid

  belongs_to :parent, polymorphic: true

  has_many :addresses, as: :parent
  has_many :carts
  has_many :orders

  has_many :activities, inverse_of: :owner


  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  before_validation :generate_password
  before_create     :expand_raw_name

  mount_uploader :photo, UserPhotoUploader

  class << self
    def find_for_facebook_oauth(auth, signed_in_resource = nil)
      user = User.where(provider: auth.provider, uid: auth.uid).first

      unless user
        user = User.create(
          raw_name:         auth.info.name,
          first_name:       auth.info.first_name,
          last_name:        auth.info.last_name,
          provider:         auth.provider,
          uid:              auth.uid,
          email:            (auth.info.email.present? ? auth.info.email : "#{UUID.generate}@host.fake"),
          password:         Devise.friendly_token[0,20],
          remote_photo_url: "http://graph.facebook.com/#{auth.uid}/picture?type=large")
      end

      user
    end

    def find_for_twitter_oauth(auth, signed_in_resource = nil)
      user = User.where(provider: auth.provider, uid: auth.uid).first

      unless user
        user = User.create(
          raw_name:         auth.info.name,
          email:            "#{UUID.generate}@host.fake",
          provider:         auth.provider,
          uid:              auth.uid,
          password:         Devise.friendly_token[0,20],
          remote_photo_url: auth.extra.raw_info.profile_image_url)
      end

      user
    end
  end

  def facebook?
    provider == "facebook"
  end

  def twitter?
    provider == "twitter"
  end

  def favorite_items(page = 1, per = 25)
    activities = Activity.
      for_owner(self).
      where(action: "favorite", subject_type: "Item").
      page(page).per(per).
      select(:subject_id)

    Item.where(id: activities.map(&:subject_id))
  end

  def boutiques_following(reload = false)
    @boutiques_following   = nil if reload
    @boutiques_following ||= Boutique.where(id: boutiques_following_ids(reload))
  end

  def boutiques_following_ids(reload = true)
    @boutiques_following_ids   = nil if reload

    @boutiques_following_ids ||= Activity.for_owner(self).
      where(action: "follow", subject_type: "Boutique").
      select(:subject_id).map(&:subject_id)
  end

  private

  def generate_password
    return if provider.present? || password.present?
    self.password =
      self.password_confirmation =
      Devise.friendly_token.first(8)
  end

  def expand_raw_name
    if self.first_name.blank?
      name = self.raw_name.split(' ', 2)

      self.first_name = name.first
      self.last_name  = name.last
    end
  end
end
