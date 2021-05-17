# frozen_string_literal: true

# Validates an associated attribute and bubles up its error to the actual model.
#
# Inspired from this post: https://stackoverflow.com/a/7387710/1435116
class BubbleUpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    return if value.valid?

    value.errors.full_messages.each do |msg|
      record.errors.add(attribute, "/ #{msg}", options.merge(value: value))
    end
  end
end
