class Category < ActiveRecord::Base
  acts_as_tree

  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: true

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def serializable_hash(opts = nil)
    opts ||= {}

    opts[:except]  = Array.wrap(opts[:except])
    opts[:except] << :items_count

    super(opts)
  end
end
