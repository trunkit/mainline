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

  before_create :generate_password
  after_create  :send_welcome_email

  validates_presence_of :first_name, :last_name, :email, if: lambda {|u| u.twitter_id.blank? && u.facebook_id.blank? }
  validates_presence_of :password, on: :update, if: lambda {|u| u.twitter_id.blank? && u.facebook_id.blank? }

  validates_uniqueness_of :email, :twitter_id, :facebook_id, allow_blank: true

  def self.from_session(sess)
    User.where("_id" => sess["user_id"]).first
  end

  private

  def generate_password
    self.password = self.password_confirmation = SecureRandom.hex[0,8]
  end

  def validate_role
    if !self.class.roles.include?(role) && !admin?
      errors.add(:role, "is invalid")
      false
    end
  end

  def send_welcome_email
    Notifier.welcome_email(self).deliver
  end
end
