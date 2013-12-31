class Brand < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

	has_many :items, -> { where(parent_id: nil) }, dependent: :destroy
end
