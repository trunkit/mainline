class Favorite < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  def self.toggle_for_user_and_item(user_id, item_id)
    user  = User.find(user_id)
    scope = user.favorites.where(item_id: item_id)

    if scope.count > 0
      scope.each(&:destroy)
      false
    else
      scope.create
      true
    end
  end
end
