# frozen_string_literal: true

require "faraday"

module MoneydanceImport
  class ApiClient
    attr_reader :logger, :api_client, :verbose

    def initialize(logger:, api_url:, verbose:)
      @logger = logger
      @verbose = verbose
      @api_client = ::Faraday.new(url: api_url) do |f|
        f.request :json
        f.response :json
        f.response :raise_error
      end
    end

    class GraphQLError < StandardError; end

    Book = Data.define(
      :id,
      :name
    ).freeze

    Register = Data.define(
      :id,
      :createdAt,
      :name,
      :type,
      :bookId,
      :parentId,
      :startsAt,
      :expiresAt,
      :currencyIsoCode,
      :notes,
      :initialBalance,
      :active,
      :defaultCategoryId,
      :institutionName,
      :accountNumber,
      :iban,
      :annualInterestRate,
      :creditLimit,
      :cardNumber
    ).freeze

    class << self
      def login_and_use(logger:, api_url:, api_email:, api_password:, verbose: false)
        client = new(logger:, api_url:, verbose:)
        client.login(email: api_email, password: api_password)

        yield client if block_given?
      rescue Faraday::ConnectionFailed => e
        logger.error "Connection to API not possible: #{e.message}"
        exit 1
      rescue
        logger.error "Query to API failed. Automatically logging out."
        client.logout
        raise
      end
    end

    def token
      api_client.headers["Authorization"]
    end

    def token=(value)
      api_client.headers["Authorization"] = "Bearer #{value}"
    end

    def map_variables_for_call(variables)
      case variables
      when Hash
        variables.transform_keys { _1.to_s.camelize(:lower) }.transform_values { map_variables_for_call(_1) }
      when Array
        variables.map { map_variables_for_call(_1) }
      else
        variables
      end
    end

    def query(query:, variables: {}, expect_success: false)
      variables = map_variables_for_call(variables)
      verbose_query(query:, variables:) if verbose
      result = api_client.post(nil, {query:, variables:}.to_json)
      if expect_success && result.body.key?("errors")
        logger.error <<~ERROR if verbose
          Query failed. Full body:
          #{JSON.pretty_generate(result.body["errors"]).indent(2)}
        ERROR
        raise GraphQLError, result.body["errors"].first["message"]
      end

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
      r = query! variables: {book: {name:, default_currency_iso_code:}}, query: <<~GQL
        mutation CreateBook($book: BookForCreateInput!) {
          createBook(input: {book: $book}) {
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

    def create_register(**args)
      # args = args.slice(:name, :type, :book_id, :initial_balance, :currency_iso_code, :active) # TODO: remove after tests
      r = query! variables: {register: args}, query: <<~GQL
        mutation CreateRegister($register: RegisterForCreateInput!) {
          createRegister(input: {register: $register}) {
            register {
              id
              createdAt
              name
              type
              bookId
              parentId
              startsAt
              expiresAt
              currencyIsoCode
              notes
              initialBalance
              active
              defaultCategoryId
              institutionName
              accountNumber
              iban
              annualInterestRate
              creditLimit
              cardNumber
            }
          }
        }
      GQL
      Register.new(**r.dig("createRegister", "register"))
    end

    private

    def verbose_query(query:, variables:)
      logger.info <<~LOG
        Querying the GraphQL Endpoint
          Query:
        #{query.indent(4)}  Variables:
        #{JSON.pretty_generate(variables || {}).indent(4)}
      LOG
    end
  end
end
