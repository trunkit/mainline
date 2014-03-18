class Activity < ActiveRecord::Base
  belongs_to :owner,   polymorphic: true
  belongs_to :subject, polymorphic: true

  scope :for_owner,   ->(owner)   { where(owner_id:   owner.id,   owner_type:   owner.class.to_s)   }
  scope :for_subject, ->(subject) { where(subject_id: subject.id, subject_type: subject.class.to_s) }
end
