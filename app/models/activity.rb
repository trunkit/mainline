class Activity < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :owner,   polymorphic: true
  belongs_to :subject, polymorphic: true

  scope :for_owner,   ->(owner)   { where(owner_id:   owner.id,   owner_type:   owner.class.to_s)   }
  scope :for_subject, ->(subject) { where(subject_id: subject.id, subject_type: subject.class.to_s) }

  after_save do
    owner.notify(action, subject) if owner.respond_to?(:notify)
    subject.notify(action, owner) if subject.respond_to?(:notify)
  end

  def self.for_notification_stream(user)
    return none if user.parent_id.blank?

    where(
      "(subject_type = ? AND subject_id = ?) OR (subject_type = ? AND subject_id IN (?))",
      user.parent_type,
      user.parent_id,
      "Item",
      (user.parent.supported_item_ids + user.parent.items.map(&:id))
    ).order(created_at: :desc)
  end
end
