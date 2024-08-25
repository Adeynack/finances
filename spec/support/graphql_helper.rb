# frozen_string_literal: true

module GraphQLHelper
  def gql(query:, variables:)
    context = {
      session: nil,
      current_api_session:
    }
    FinancesSchema.execute(query, variables:, context:)
  end

  def gql_data(query:, variables:)
    result = gql(query:, variables:)
    expect(result["errors"]).to be_blank
    result.fetch("data")
  end
end

RSpec.configure do |config|
  config.include GraphQLHelper, type: :graphql
end
