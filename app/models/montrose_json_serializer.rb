# frozen_string_literal: true

class MontroseJSONSerializer
  class << self
    def load(source)
      return nil if source.blank?
      raise ArgumentError, "expecting Montrose Recurrence to be serialized as a hash" unless source.is_a?(Hash)

      Montrose::Recurrence.new(source)
    end

    def dump(object)
      object.to_hash
    end
  end
end
