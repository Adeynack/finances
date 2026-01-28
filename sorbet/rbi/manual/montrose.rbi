# typed: strong
# frozen_string_literal: true

module Montrose
  class Recurrence
    sig do
      params(
        every: T.nilable(T.any(Symbol, Integer)),
        starts: T.nilable(T.any(Date, Time)),
        until: T.nilable(T.any(Date, Time)),
        total: T.nilable(Integer),
        day: T.nilable(T.any(Integer, Symbol, T::Array[T.any(Integer, Symbol)])),
        interval: T.nilable(Integer)
      ).void
    end
    def initialize(
      every: nil,
      starts: nil,
      until: nil,
      total: nil,
      day: nil,
      interval: nil
    ); end

    sig { params(date: T.any(Date, Time)).returns(Montrose::Recurrence) }
    def starting(date); end

    sig { params(count: Integer).returns(T::Array[Time]) }
    def first(count = 1); end

    sig { returns(String) }
    def to_json; end
  end

  class << self
    sig do
      params(
        every: T.nilable(T.any(Symbol, Integer)),
        starts: T.nilable(T.any(Date, Time)),
        until: T.nilable(T.any(Date, Time)),
        total: T.nilable(Integer),
        day: T.nilable(T.any(Integer, Symbol, T::Array[T.any(Integer, Symbol)])),
        interval: T.nilable(Integer)
      ).returns(Montrose::Recurrence)
    end
    def every(
      every: nil,
      starts: nil,
      until: nil,
      total: nil,
      day: nil,
      interval: nil
    ); end
  end
end

class MontroseJSONSerializer
  sig { params(value: T.nilable(Montrose::Recurrence)).returns(T.nilable(String)) }
  def self.dump(value); end

  sig { params(value: T.nilable(String)).returns(T.nilable(Montrose::Recurrence)) }
  def self.load(value); end
end
