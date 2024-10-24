# frozen_string_literal: true

require "faraday"

module MoneydanceImport
  class ApiClient
    attr_reader :api_url, :verbose
    attr_accessor :bar

    def initialize(api_url:, verbose:)
      @bar = nil
      @verbose = verbose
      @http_client = ::Faraday.new(url: api_url) do |f|
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

    Category = Data.define(
      :id,
      :name,
      :income,
      :book_id,
      :parent_id,
      :currency_iso_code,
      :notes,
      :active
    ).freeze

    Account = Data.define(
      :id,
      :name,
      :type,
      :book_id,
      :parent_id,
      :starts_at,
      :expires_at,
      :currency_iso_code,
      :notes,
      :initial_balance,
      :active,
      :default_category_id,
      :institution_name,
      :account_number,
      :iban,
      :annual_interest_rate,
      :credit_limit,
      :card_number
    ).freeze

    class << self
      def login_use_logout(api_url:, api_email:, api_password:, verbose: false)
        client = new(api_url:, verbose:)
        begin
          client.log "Logging in"
          client.login(email: api_email, password: api_password)

          yield client if block_given?
          nil
        rescue Faraday::ConnectionFailed => e
          client.log "Connection to API not possible: #{e.message}"
          exit 1
        ensure
          client.log "Logging out"
          client.logout
        end
      end
    end

    def log(message)
      if bar
        bar.log message
      else
        puts message
      end
    end

    def token
      @http_client.headers["Authorization"]
    end

    def token=(value)
      @http_client.headers["Authorization"] = "Bearer #{value}"
    end

    def to_camel_string_hash(variables)
      case variables
      when Hash
        variables.transform_keys { _1.to_s.camelize(:lower) }.transform_values { to_camel_string_hash(_1) }
      when Array
        variables.map { to_camel_string_hash(_1) }
      else
        variables
      end
    end

    def to_underscore_sym_hash(result)
      case result
      when Hash
        result.transform_keys { _1.underscore.to_sym }.transform_values { to_underscore_sym_hash(_1) }
      when Array
        result.map { to_underscore_sym_hash(_1) }
      else
        result
      end
    end

    def query(query:, variables: {}, expect_success: false)
      variables = to_camel_string_hash(variables)
      verbose_query(query:, variables:) if verbose
      result = @http_client.post(nil, {query:, variables:}.to_json)
      if expect_success && result.body.key?("errors")
        log <<~ERROR if verbose
          Query failed. Full body:
          #{JSON.pretty_generate(result.body["errors"]).indent(2)}
        ERROR
        raise GraphQLError, result.body["errors"].first["message"]
      end

      to_underscore_sym_hash(result.body)
    end

    def query!(query:, variables: {})
      query(query:, variables:, expect_success: true).fetch(:data)
    end

    def query_all_pages!(query:, variables: {})
      result = []
      after = nil
      has_next_page = true
      while has_next_page
        r = query! query:, variables: variables.merge(after:)
        page_info = r.dig(r.keys.sole, :page_info)
        raise GraphQLError, "could not find page info" unless page_info
        raise GraphQLError, "query must include page info's hasNextPage" unless page_info.key?(:has_next_page)
        raise GraphQLError, "query must include page info's endCursor" unless page_info.key?(:end_cursor)

        has_next_page = page_info[:has_next_page]
        after = page_info[:end_cursor]

        result.push r
      end

      result
    end

    def login(email:, password:)
      result = query! variables: {email:, password:}, query: <<~GQL
        mutation LogIn($email: String!, $password: String!) {
          logIn(input: {email: $email, password: $password}) {
            token
          }
        }
      GQL
      self.token = result.dig(:log_in, :token)
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
      r = query_all_pages! query: <<~GQL
        query ListBooks($after: String) {
          books(after: $after) {
            pageInfo {
              hasNextPage
              endCursor
            }
            nodes {
              id
              name
            }
          }
        }
      GQL

      r.flat_map { _1.dig(:books, :nodes) }.map { Book.new(**_1) }
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
      Book.new(**r.dig(:create_book, :book))
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

    def create_category(category:)
      r = query! variables: {category:}, query: <<~GQL
        mutation CreateCategory($category: CategoryForCreateInput!) {
          createCategory(input: {category: $category}) {
            category {
              id
              name
              income
              bookId
              parentId
              currencyIsoCode
              notes
              active
            }
          }
        }
      GQL
      Category.new(**r.dig(:create_category, :category))
    end

    def create_account(account:)
      r = query! variables: {account:}, query: <<~GQL
        mutation CreateAccount($account: AccountForCreateInput!) {
          createAccount(input: {account: $account}) {
            account {
              id
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
      Account.new(**r.dig(:create_account, :account))
    end

    def create_reminder(reminder:)
      query! variables: {reminder:}, query: <<~GQL
        mutation CreateReminder($reminder: ReminderForCreateInput!) {
          createReminder(input: {reminder: $reminder}) {
            clientMutationId
          }
        }
      GQL
    end

    def create_exchange(exchange:)
      query! variables: {exchange:}, query: <<~GQL
        mutation CreateExchange($exchange: ExchangeForCreateInput!) {
          createExchange(input: {exchange: $exchange}) {
            clientMutationId
          }
        }
      GQL
    end

    private

    def verbose_query(query:, variables:)
      log <<~LOG
        Querying the GraphQL Endpoint
          Query:
        #{query.indent(4)}  Variables:
        #{JSON.pretty_generate(variables || {}).indent(4)}
      LOG
    end
  end
end
