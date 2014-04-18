module StreamHelper
  def current_user_owns_item?(item)
    current_user && current_user.parent_type == "Boutique" && current_user.parent_id == item.boutique_id
  end
end
