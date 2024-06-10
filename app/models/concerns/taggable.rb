# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :subject, dependent: :delete_all
    has_many :tags, through: :taggings

    def tag(tag)
      tag_record = tag.is_a?(Tag) ? tag : Tag.find_or_create_by(name: tag)
      tags << tag_record unless tags.exists?(name: tag_record.name)
    end

    def untag(tag)
      tag_record = Tag.find_by(name: tag) unless tag.is_a?(Tag)
      return if tag_record.nil?

      taggings.find_by(tag: tag_record)&.destroy!
    end
  end
end
