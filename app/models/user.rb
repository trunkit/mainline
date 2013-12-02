class User
  include Mongoid::Document

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         omniauthable: [:facebook, :twitter]
end
