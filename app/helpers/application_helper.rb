module ApplicationHelper
  @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, filter_html: true, no_images: true, no_links: true, no_styles: true).freeze

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

  def active_css_class(matcher)
    if matcher.is_a?(Regexp)
      matcher.match(request.fullpath) ? "active" : nil
    else
      request.fullpath.index(matcher) ? "active" : nil
    end
  end

  def markdown(string)
    @@markdown.render(string).html_safe
  end
end
