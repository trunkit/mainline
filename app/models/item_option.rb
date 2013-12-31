class ItemOption < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  validates_uniqueness_of :value, scope: [:item_id, :name]
end
