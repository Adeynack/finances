# frozen_string_literal: true
# typed: true

class MontroseJSONSerializer
  class << self
    extend T::Sig

    sig { params(source: T.nilable(T::Hash[T.untyped, T.untyped])).returns(T.nilable(Montrose::Recurrence)) }
    def load(source)
      return nil if source.blank?
      raise ArgumentError, "expecting Montrose Recurrence to be serialized as a hash" unless T.unsafe(source).is_a?(Hash)

      Montrose::Recurrence.new(source)
    end

    sig { params(object: T.nilable(Montrose::Recurrence)).returns(T.nilable(T::Hash[T.untyped, T.untyped])) }
    def dump(object)
      object&.to_hash
    end
  end
end
