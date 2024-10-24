# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Query Books", type: :graphql do
  fixtures :all

  let(:query) do
    <<~GQL
      query Books {
        books {
          nodes {
            id
          }
        }
      }
    GQL
  end
  let(:queried_books) { gql_data(query:).dig("books", "nodes") }

  before do
    login!(user:) if user
  end

  context "when not logged in" do
    let(:user) { nil }

    it "returns no book" do
      expect(gql_errors(query:).sole["message"]).to eq FinancesSchema::NOT_FOUND_OR_NOT_AUTHORIZED_ERROR_MESSAGE
    end
  end

  context "when logged in as an admin" do
    let(:user) { users :cthulhu }

    it "returns all books" do
      expect(queried_books.size).to be > user.books.count
    end
  end

  context "when logged in as a normal user" do
    let(:user) { users :joe }

    it "returns only the user's owned books" do
      expect(queried_books.size).to eq user.books.count
    end
  end
end
