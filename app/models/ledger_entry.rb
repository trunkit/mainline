class LedgerEntry < ActiveRecord::Base
  belongs_to :whodunnit, polymorphic: true
end
