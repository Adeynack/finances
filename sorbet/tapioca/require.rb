# frozen_string_literal: true

# Custom requires for Tapioca DSL generation
require "rails"
require_relative "../../config/environment"

# Eager load application code
Rails.application.eager_load!

# Load concerns and validators
Dir[Rails.root.join("app/models/concerns/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/validators/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/models/**/*.rb")].each { |f| require f }
