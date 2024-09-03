# frozen_string_literal: true

unless ENV["COVERAGE"] == "0" # enabled by default
  require "simplecov"
  SimpleCov.start "rails" do
    enable_coverage :branch
    primary_coverage :branch

    # Initialized with the coverage at time of starting coverage.
    # As coverage goes up, adjust them higher.
    # GOAL: Never lower them, so any new code is ensured to be tested.
    minimum_coverage line: 80, branch: 52 if ENV["MIN_COV"] || ENV["CI"]

    add_group "GraphQL", "app/graphql"
    add_group "Policies", "app/policies"
    add_group "Validators", "app/validators"

    if ENV["CI"]
      formatter SimpleCov::Formatter::SimpleFormatter
    else
      formatter SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter
      ])
    end
  end
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random
end
