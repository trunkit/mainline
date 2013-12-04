class Ability
  include CanCan::Ability

  def initialize(user)
    case user.roles
    when :system
      can :masquerade, :all
    when :admin
      can :manage, Item, boutique_id: user.parent_id
      can :manage, User, parent_id: user.parent_id, parent_type: user.parent_type
    end
  end
end
