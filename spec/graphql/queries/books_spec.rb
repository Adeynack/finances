# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Query Books", type: :graphql do
  fixtures :users, :books

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
  let(:queried_books) do
    gql_data(query:).dig("books", "nodes")
  end

  before do
    login!(user:) if user
  end

  context "when not logged in" do
    let(:user) { nil }

    it "returns no book" do
      expect(queried_books).to be_empty
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
