class Category < ActiveRecord::Base
  acts_as_tree

  has_and_belongs_to_many :items
end
