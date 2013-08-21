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
  field :a,  as: :admin,           type: Boolean, default: false

  field :p,  as: :picture,         type: String

  has_secure_password validations: false

  cattr_reader :roles
  @@roles = [:shopper, :boutique, :brand]

  before_validation :validate_role

  validates_presence_of :password, if: lambda {|u| u.twitter_id.blank? && u.facebook_id.blank? }

  validates_uniqueness_of :email, :twitter_id, :facebook_id, allow_blank: true

  def self.from_session(sess)
    User.where("_id" => sess["user_id"]).first
  end

  def ready?
    state == :ready || state == :confirmed
  end

  private

  def validate_role
    if !self.class.roles.include?(role) && !admin?
      errors.add(:role, "is invalid")
      false
    end
  end
end
