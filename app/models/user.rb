class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :fn, as: :first_name,      type: String
  field :ln, as: :last_name,       type: String
  field :e,  as: :email,           type: String
  field :pd, as: :password_digest, type: String
  field :g,  as: :gender,          type: String

  field :t,  as: :twitter_id,      type: String
  field :f,  as: :facebook_id,     type: String

  field :r,  as: :role,            type: Symbol

  has_secure_password
  field :s,  as: :state,           type: Symbol

  field :p,  as: :picture,         type: String


  cattr_reader :roles
  @@roles = [:shopper, :boutique, :brand, :admin]

  cattr_reader :user_states
  @@user_states = [:initializing, :ready, :confirmed]

  before_validation :validate_role
  before_create     :initialize_state


  def self.from_session(sess)
    User.where("_id" => sess["user_id"]).first
  end

  def ready?
    state == :ready || state == :confirmed
  end

  private

  def validate_role
    if !self.class.roles.include?(role)
      errors.add(:role, "is invalid")
      false
    end
  end

  def initialize_state
    self.user_state = case role
    when :shopper then :initializing
    when :admin   then :confirmed
    else               :ready
    end

    true
  end
end
