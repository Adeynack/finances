# frozen_string_literal: true

# TODO: Shimmer
module AttributeStripping
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.class.columns.each do |column|
        next unless [:text, :string, :enum].include?(column.type) # only strip text based columns

        self[column.name] = self[column.name].strip.then { |e| column.null ? e.presence : e } unless self[column.name].nil?
      end
    end
  end
end
