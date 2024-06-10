# frozen_string_literal: true

module HeaderBarHelper
  def crumb(text, target = nil, *link_to_args, **link_to_kwargs)
    content_tag "li", class: "crumbs__crumb" do
      if target
        link_to text, target, *link_to_args, **link_to_kwargs
      else
        content_tag "span", text
      end
    end
  end
end
