# frozen_string_literal: true

source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "rack-cors"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "tzinfo-data", platforms: [:windows, :jruby]
gem "bootsnap", require: false
# gem "image_processing", "~> 1.2" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]

# GraphQL
gem "graphql", "~> 2.3"
gem "graphiql-rails"

# Extensions
gem "shimmer"
gem "dotenv-rails"
gem "oj"
gem "kaminari"
gem "countries", require: "countries/global"
gem "pundit"

# Data
gem "closure_tree"
gem "awesome_print"
gem "table_print"
gem "money-rails"
gem "iban-tools"
gem "montrose"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :windows]
  gem "rspec-rails"
end

group :test do
  gem "fuubar"
  gem "rack_session_access"
end

group :development do
  gem "web-console"
  gem "guard"
  gem "guard-rspec"
  gem "standard", ">= 1.35.1"
  gem "solargraph"
  gem "solargraph-standardrb"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
  gem "rubocop-rake"
  gem "rubocop-graphql"
  gem "annotate", github: "ctran/annotate_models", branch: "develop"
  gem "chusaku", require: false
end
