class User < ActiveRecord::Base
  include RoleModel
  roles :system, :admin

  has_paper_trail
  acts_as_paranoid

  belongs_to :parent, polymorphic: true

  has_many :addresses, as: :parent
  has_many :carts

  has_many :activities, inverse_of: :owner

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  before_validation :generate_password
  after_create      :welcome_email

  mount_uploader :photo, UserPhotoUploader

  delegate :items, to: :parent

  class << self
    def new_with_session(params, session)
      super.tap do |user|
        if session["devise.omniauth_data"]
          user.assign_attributes(extract_omniauth(session["devise.omniauth_data"]))
        end
      end
    end

    def find_for_oauth(auth, signed_in_resource = nil)
      User.where(auth.slice(:provider, :uid)).first_or_create(extract_omniauth(auth))
    end

    def extract_omniauth(auth)
      attrs = {
        raw_name:   auth.info.name,
        first_name: auth.info.first_name,
        last_name:  auth.info.last_name,
        provider:   auth.provider,
        uid:        auth.uid,
        email:      auth.info.email,
        password:   Devise.friendly_token[0,20]
      }

      attrs.merge!(send("extract_omniauth_#{auth.provider}", auth))
      attrs.reject!{|k,v| v.blank? }
      attrs
    end

  private
    def extract_omniauth_twitter(auth)
      { remote_photo_url: auth.extra.raw_info.profile_image_url }
    end

    def extract_omniauth_facebook(auth)
      { remote_photo_url: "http://graph.facebook.com/#{auth.uid}/picture?type=large" }
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def raw_name=(val)
    self[:raw_name] = val
    self.first_name = raw_name.to_s.split(' ', 2).first unless first_name.present?
    self.last_name  = raw_name.to_s.split(' ', 2).last  unless last_name.present?
    val
  end

  def facebook?
    provider == "facebook"
  end

  def twitter?
    provider == "twitter"
  end

  def favorite_item_activity_ids(reload = false)
    favorite_item_activities(reload).map(&:id)
  end

  def favorite_item_activities(reload = false)
    return @favorite_item_activities if @favorite_item_activities && !reload

    favorite_activity_ids ||= Activity.
      for_owner(self).
      where(action: "favorite", subject_type: "Activity").
      select(:subject_id).map(&:subject_id)

    @favorite_item_activities ||= Activity.where(subject_type: "Item", id: favorite_activity_ids)
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

  def toggle_favorite(activity)
    scope = Activity.for_subject(activity).for_owner(self).where(action: "favorite")

    if activity = scope.first
      activity.destroy
      false
    else
      scope.create
      true
    end
  end

  private

  def generate_password
    return if provider.present? || password.present?
    self.password =
      self.password_confirmation =
      Devise.friendly_token.first(8)
  end

  def welcome_email
    Notifier.welcome_email(self).deliver
  end
end
