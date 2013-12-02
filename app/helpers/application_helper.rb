module ApplicationHelper
  def main_nav(hide_main_nav = false)
    if !hide_main_nav
      type = current_user.parent_type.try(:downcase)
      type = "user" if type.blank?

      render("layouts/#{type}_nav")
    end
  end
end
