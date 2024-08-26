# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CreateExchange", type: :graphql do
  fixtures :all

  let(:query) do
    <<~GQL
      mutation CreateExchange($exchange: ExchangeForCreateInput!) {
        createExchange(input: {exchange: $exchange}) {
          exchange {
            id
            createdAt
            updatedAt
            date
            registerId
            cheque
            description
            memo
            status
            tags
            importOrigin {
              system
              id
            }
            splits {
              id
              createdAt
              updatedAt
              exchangeId
              registerId
              amount
              counterpartAmount
              memo
              status
              tags
              importOrigin {
                system
                id
              }
            }
          }
        }
      }
    GQL
  end

  context "logged as Joe" do
    before { login! user: users(:joe) }

    it "creates a new exchange" do
      variables = {"exchange" => {
        "id" => "c8c2a2b9-4772-4b59-a784-df73e3368374",
        "createdAt" => "2016-04-02T17:56:00Z",
        "date" => "2016-02-15",
        "registerId" => registers(:joe_first_bank).id,
        "cheque" => "CHQ423",
        "description" => "Foodelidou",
        "memo" => "Lorem ipsum",
        "status" => "cleared",
        "importOrigin" => {system: "Quicken", id: "10e2f5a1-a0d4-44b5-876c-37cf309f36e9"},
        "tags" => ["A", "B", "C", "D"],
        "splits" => [
          {
            "createdAt" => nil, # expecting it to be set to the same as the exchange itself
            "registerId" => registers(:joe_fruits).id,
            "amount" => 1234,
            "counterpartAmount" => -1234,
            "memo" => "It's settled, then...",
            "status" => "uncleared"
          },
          {
            "createdAt" => "2016-05-03T12:00:00Z",
            "registerId" => registers(:joe_meat).id,
            "amount" => 10100,
            "counterpartAmount" => -16432,
            "memo" => nil,
            "status" => "reconciling",
            "tags" => ["X"]
          }
        ]
      }}
      created_exchange = gql_data(query:, variables:).dig("createExchange", "exchange")
      expect(created_exchange["id"]).to eq "c8c2a2b9-4772-4b59-a784-df73e3368374"
      expect(created_exchange["tags"]).to match_array ["A", "B", "C", "D"]
      expect(created_exchange["splits"].length).to eq 2
      expect(created_exchange["splits"][0]["tags"]).to match_array []
      expect(created_exchange["splits"][1]["tags"]).to match_array ["X"]
    end
  end
end
