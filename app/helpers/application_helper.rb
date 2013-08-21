module ApplicationHelper
  def main_nav(hide_main_nav = false)
    render("layouts/#{current_user.role}_nav") unless hide_main_nav
  end
end
