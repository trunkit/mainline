class User < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  has_many :addresses
  has_many :orders

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  before_validation :generate_password
  before_create     :expand_raw_name

  class << self
    def find_for_facebook_oauth(auth, signed_in_resource = nil)
      user = User.where(provider: auth.provider, uid: auth.uid).first

      unless user
        user = User.create(
          raw_name:   auth.info.name,
          first_name: auth.info.first_name,
          last_name:  auth.info.last_name,
          provider:   auth.provider,
          uid:        auth.uid,
          email:      auth.info.email,
          password:   Devise.friendly_token[0,20])
      end

      user
    end

    def find_for_twitter_oauth(auth, signed_in_resource = nil)
      user = User.where(provider: auth.provider, uid: auth.uid).first

      unless user
        user = User.create(
          raw_name: auth.info.name,
          email:    "#{UUID.generate}@fake",
          provider: auth.provider,
          uid:      auth.uid,
          password: Devise.friendly_token[0,20])
      end
    end
  end

  def facebook?
    provider == "facebook"
  end

  def twitter?
    provider == "twitter"
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
