# frozen_string_literal: true

module GraphQLHelper
  def gql(query:, variables: nil)
    context = {
      session: nil,
      current_api_session:
    }
    FinancesSchema.execute(query, variables:, context:)
  end

  def gql_data(query:, variables: nil)
    result = gql(query:, variables:)
    raise "GraphQL Errors: #{JSON.pretty_generate(result["errors"])}" if result["errors"].present?
    result.fetch("data")
  end

  def gql_errors(query:, variables: nil)
    errors = gql(query:, variables:)["errors"]
    raise "GraphQL did not return errors as expected" unless errors.present?
    errors
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graphql
end
