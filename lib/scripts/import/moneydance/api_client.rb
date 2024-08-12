# frozen_string_literal: true

require "faraday"

module MoneydanceImport
  class ApiClient
    attr_reader :api_client

    def initialize(api_url:)
      @api_client = ::Faraday.new(url: api_url) do |f|
        f.request :json
        f.response :json
        f.response :raise_error
      end
    end

    class GraphQLError < StandardError; end

    Book = Data.define(:id, :name).freeze

    class << self
      def login_and_use(api_url:, api_email:, api_password:)
        client = new(api_url:)
        client.login(email: api_email, password: api_password)
        begin
          yield client if block_given?
        rescue
          client.logout
          raise
        end
      end
    end

    def token
      api_client.headers["Authorization"]
    end

    def token=(value)
      api_client.headers["Authorization"] = "Bearer #{value}"
    end

    def query(query:, variables: {}, expect_success: false)
      variables = variables.transform_keys { _1.to_s.camelize(:lower) }
      result = api_client.post(nil, {query:, variables:}.to_json)
      # binding.irb
      raise GraphQLError, result.body["errors"].first["message"] if expect_success && result.body.key?("errors")

      result.body
    end

    def query!(query:, variables: {})
      query(query:, variables:, expect_success: true)["data"]
    end

    def login(email:, password:)
      result = query! variables: {email:, password:}, query: <<~GQL
        mutation LogIn($email: String!, $password: String!) {
          logIn(input: {email: $email, password: $password}) {
            token
          }
        }
      GQL
      self.token = result.dig("logIn", "token")
    end

    def logout
      query! query: <<~GQL
        mutation LogOut {
          logOut(input: {}) {
            clientMutationId
          }
        }
      GQL
    end

    def list_books
      r = query! query: <<~GQL
        query ListBooks {
          books {
            id
            name
          }
        }
      GQL
      r["books"].map { Book.new(**_1) }
    end

    def create_book(name:, default_currency_iso_code:)
      r = query! variables: {name:, default_currency_iso_code:}, query: <<~GQL
        mutation CreateBook($name: String!, $defaultCurrencyIsoCode: String!) {
          createBook(input: {
            name: $name,
            defaultCurrencyIsoCode: $defaultCurrencyIsoCode
          }) {
            book {
              id
              name
            }
          }
        }
      GQL
      Book.new(**r.dig("createBook", "book"))
    end

    def destroy_book_fast(id:)
      query! variables: {id:}, query: <<~GQL
        mutation DestroyBookFast($id: ID!) {
          destroyBookFast(input: {
            id: $id
          }) {
            clientMutationId
          }
        }
      GQL
    end
  end
end
