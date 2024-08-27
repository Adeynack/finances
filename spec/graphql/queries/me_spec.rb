# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me", type: :graphql do
  fixtures :users

  let(:query) do
    <<~GQL
      query Me {
        me {
          email
          displayName
        }
      }
    GQL
  end
  let(:joe) { users :joe }
  let(:me_user) { gql_data(query:).dig("me") }

  context "when not logged in" do
    it "returns no 'me' user" do
      expect(me_user).to be_nil
    end
  end

  context "when logged in" do
    before { login! user: users(:joe) }

    it "returns the currently logged user as 'me'" do
      expect(me_user).to be_present
      expect(me_user["email"]).to eq joe.email
      expect(me_user["displayName"]).to eq joe.display_name
    end
  end
end
