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

  cattr_reader :roles
  @@roles = [:shopper, :boutique, :brand, :admin]

  before_save :validate_role

  def self.from_session(sess)
    User.where("_id" => sess["user_id"]).first
  end

  private

  def validate_role
    if !self.class.roles.include?(role)
      errors.add(:role, "is invalid")
      false
    end
  end
end
