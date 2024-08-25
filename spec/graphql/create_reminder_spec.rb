# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CreateReminder", type: :graphql do
  fixtures :all

  context "logged in as Joe" do
    before { login! user: users(:joe) }

    it "creates a new reminder" do
      query = <<~GQL
        mutation CreateReminder($reminder: ReminderForCreateInput!) {
          createReminder(input: {reminder: $reminder}) {
            reminder {
              id
              splits {
                tags
              }
            }
          }
        }
      GQL
      variables = {"reminder" => {
        "bookId" => books(:joe).id,
        "importOrigin" => {system: "moneydance", id: "123"},
        "title" => "Foo",
        "description" => nil,
        "mode" => "auto_commit",
        "firstDate" => "2020-06-01",
        "lastDate" => "2030-12-31",
        "lastCommitAt" => "2024-02-20",
        "recurrence" => {
          "every" => "week"
        },
        "exchangeRegisterId" => registers(:joe_first_bank).id,
        "exchangeDescription" => "Qwe asd zxc",
        "exchangeMemo" => "Foo de li doo.\nDi dudel dö.",
        "exchangeStatus" => "cleared",
        "splits" => [
          {
            "importOrigin" => {system: "moneydance", id: "3432"},
            "registerId" => registers(:joe_fruits).id,
            "amount" => 1200,
            "counterpartAmount" => nil,
            "memo" => "Bla bla bla split #1",
            "status" => "uncleared",
            "tags" => ["a", "b"]
          },
          {
            "importOrigin" => {system: "moneydance", id: "37679"},
            "registerId" => registers(:joe_meat).id,
            "amount" => 4399,
            "counterpartAmount" => nil,
            "memo" => "Bla bla bla split #2",
            "status" => "reconciling",
            "tags" => ["a", "c"]
          }
        ]
      }}
      created_reminder = gql_data(query:, variables:).dig("createReminder", "reminder")
      expect(created_reminder["id"]).to be_present
      expect(created_reminder["splits"].size).to eq 2
      expect(created_reminder["splits"][0]["tags"]).to match_array ["a", "b"]
      expect(created_reminder["splits"][1]["tags"]).to match_array ["a", "c"]
    end
  end
end
