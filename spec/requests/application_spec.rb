# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Application", type: :request do
  fixtures :users

  let(:headers) { nil }
  let(:session) { {} }
  let!(:api_session) do
    # Ensure the presence of a valid API session.
    ApiSession.create! user: users(:joe)
  end

  subject do
    # This spec is not testing the behavior of this specific controller.
    # This is simply pointing at any controller inheriting from `ApplicationController`.
    post("/graphql", headers:)
    response
  end

  describe "Session & Authentication" do
    context "when no authentication mean is provided" do
      it "is performed normally" do
        should have_http_status :ok
      end
    end

    context "when authenticating with a Bearer Token" do
      let(:headers) { {"Authorization" => bearer_token} }

      context "when the bearer token is properly" do
        context "and token is valid" do
          let(:bearer_token) { "Bearer #{api_session.token}" }

          it("is authorized") { should have_http_status :ok }
        end

        context "and token is missing" do
          let(:bearer_token) { "Bearer " }

          it("is unauthorized") { should have_http_status :unauthorized }
        end

        context "and token is invalid" do
          let(:bearer_token) { "Bearer 760403e3-c220-4a81-b6d9-8df04031d51b" }

          it("is unauthorized") { should have_http_status :unauthorized }
        end
      end

      context "when the token does not start with 'Bearer'" do
        let(:bearer_token) { api_session.token }

        it("is unauthorized") { should have_http_status :unauthorized }
      end
    end

    context "when authenticating with a cookie" do
      let(:session) { {api_session_token:} }

      before do
        allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
      end

      context "and token is valid" do
        let(:api_session_token) { api_session.token }

        it("is authorized") { should have_http_status :ok }
      end

      context "and token is invalid" do
        let(:api_session_token) { "760403e3-c220-4a81-b6d9-8df04031d51b" }

        it("is unauthorized") { should have_http_status :unauthorized }
      end
    end
  end
end
