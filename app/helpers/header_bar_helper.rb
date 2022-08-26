# frozen_string_literal: true

module HeaderBarHelper
  def nav_item_link_to(text, path, title: nil)
    content_tag "span", class: "nav-item" do
      link_to_unless_current text, path, class: "nav-link", title: do
        content_tag "span", text, class: "nav-text active", title:
      end
    end
  end
end
