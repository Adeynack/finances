# frozen_string_literal: true

class FinancesSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Union and Interface Resolution
  def self.resolve_type(abstract_type, obj, ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Limit the size of incoming queries:
  max_query_string_tokens(5000)

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Limit the depth of queries (https://graphql-ruby.org/queries/complexity_and_depth#prevent-deeply-nested-queries)
  max_depth 15

  # Limit the complexity of queries (https://graphql-ruby.org/queries/complexity_and_depth#prevent-complex-queries)
  max_complexity 300

  # Default maximum page size (https://graphql-ruby.org/schema/definition.html#default-limits)
  default_max_page_size 20

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, type_definition, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end

  # Error Handling
  # https://graphql-ruby.org/errors/error_handling.html

  NOT_FOUND_OR_NOT_AUTHORIZED_ERROR_MESSAGE = "Trying to access something that either does not exist, or to which you do not have access"

  rescue_from(Pundit::NotAuthorizedError) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, NOT_FOUND_OR_NOT_AUTHORIZED_ERROR_MESSAGE
  end
end
