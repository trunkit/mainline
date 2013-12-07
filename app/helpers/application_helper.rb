module ApplicationHelper
  def main_nav(hide_main_nav = false)
    if !hide_main_nav
      if current_user
        type = current_user.parent_type.try(:downcase)
        type = "user" if type.blank?

        render("layouts/#{type}_nav")
      else
        render("layouts/public_nav")
      end
    end
  end
end
