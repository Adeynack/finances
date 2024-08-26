# frozen_string_literal: true

module Mutations
  class CreateExchange < BaseMutation
    argument :exchange, Types::ExchangeForCreateInputType, required: true

    field :exchange, Types::ExchangeType, null: false

    def resolve(exchange:)
      new_exchange = authorize Exchange.new(exchange.to_h.except(:import_origin, :splits, :tags))
      new_exchange.import_origin = exchange.import_origin&.to_model
      exchange.tags&.each { new_exchange.tag(_1) }
      exchange.splits.each do |s|
        new_split = new_exchange.splits.new(s.to_h.except(:import_origin, :tags))
        new_split.import_origin = s.import_origin&.to_model
        s.tags&.each { new_split.tag(_1) }
      end
      new_exchange.save!
      {exchange: new_exchange}
    end
  end
end
