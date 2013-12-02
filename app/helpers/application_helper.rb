module ApplicationHelper
  def main_nav(hide_main_nav = false)
    if !hide_main_nav
      nav_type = current_user.parent_type.downcase
      nav_type = "user" if nav_type.blank?

      render("layouts/#{current_user.role}_nav")
    end
  end
end
