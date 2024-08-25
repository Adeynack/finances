# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :subject, dependent: :delete_all
    has_many :tags, through: :taggings

    def tag(tag)
      tag_record = tag.is_a?(Tag) ? tag : Tag.find_or_create_by(name: tag)
      already_tagged = (new_record? || tags.loaded?) ? tags.any? { _1.name == tag_record.name } : tags.exists?(name: tag_record.name)
      tags << tag_record unless already_tagged
    end

    def untag(tag)
      tag_record = Tag.find_by(name: tag) unless tag.is_a?(Tag)
      return if tag_record.nil?

      taggings.find_by(tag: tag_record)&.destroy!
    end

    def tag_names
      tags.map(&:name)
    end
  end
end
