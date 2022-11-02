# frozen_string_literal: true

module HeaderBarHelper
  def nav_item_link_to(text, path, title: nil, strict: false)
    content_tag "span", class: "navbar__item" do
      url = url_for(path)
      url_path = URI.parse(url).path
      super_path_of_request = strict ? (url_path == request.path) : /^#{url_path}($|\/).*/i.match?(request.path)
      link_to text, url, {class: class_names("navbar__item--truncated", "navbar__link", "navbar__link--active": super_path_of_request), title:}
    end
  end
end
