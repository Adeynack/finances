# frozen_string_literal: true

module ApplicationHelper
  def todo(text)
    content_tag "span", class: "todo" do
      "\u{1F534} #{text} \u{1F534}"
    end
  end
end
