class User < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  has_many :addresses
  has_many :orders

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

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
end
