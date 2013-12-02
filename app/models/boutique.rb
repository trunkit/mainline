class Boutique < ActiveRecord::Base
  has_many :locations, as: :company
  has_many :users, as: :parent
end
