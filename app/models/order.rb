class Order < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  has_one :cart
  belongs_to :user
end
