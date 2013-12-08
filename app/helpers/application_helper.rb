module ApplicationHelper
  def main_nav
    return render("layouts/public_nav") unless current_user

    if current_user.has_role?(:system)
      render("layouts/system_nav")
    else
      type = current_user.parent_type.try(:downcase)
      type = "user" if type.blank?

      render("layouts/#{type}_nav")
    end
  end
end
