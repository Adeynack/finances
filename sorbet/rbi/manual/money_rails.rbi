# typed: strong
# frozen_string_literal: true

module Money
  class Currency
    sig { returns(String) }
    def iso_code; end

    sig { returns(String) }
    def name; end

    sig { returns(String) }
    def symbol; end

    sig { params(iso_code: String).void }
    def initialize(iso_code); end

    sig { returns(T::Array[Money::Currency]) }
    def self.all; end
  end
end
