# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL", type: :request do
  let(:gql_path) { "/graphql" }
  let(:query) do
    <<~GQL
      query Me {
        me {
          displayName
        }
      }
    GQL
  end
  let(:single_error) { json["errors"].sole }
  let(:single_error_message) { single_error["message"] }

  describe "POST /graphql" do
    context "when query is not given" do
      it "fails" do
        post gql_path, params: {}
        expect(response).to have_http_status :ok
        expect(json).not_to have_key "data"
        expect(single_error_message).to eq "No query string was present"
      end
    end

    context "when query is valid" do
      it "fails" do
        post gql_path, params: {query:}
        expect(response).to have_http_status :ok
        expect(json).not_to have_key "errors"
        expect(json).to have_key "data"
        expect(json["data"]).to have_key "me"
        expect(json.dig("data", "me")).to be_nil
      end
    end
  end
end
