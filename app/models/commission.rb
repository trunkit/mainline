class Commission < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail
end
