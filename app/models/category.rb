class Category < ActiveRecord::Base
  acts_as_tree

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :parent_id

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
