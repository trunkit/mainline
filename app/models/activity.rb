class Activity < ActiveRecord::Base
  belongs_to :owner,   polymorphic: true
  belongs_to :subject, polymorphic: true
end
