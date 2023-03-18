# frozen_string_literal: true

source "https://rubygems.org"
ruby File.read(".ruby-version").strip

# Core
gem "rails"
gem "puma"

# Database
gem "pg"
gem "redis"

# Performance
gem "oj"
gem "bootsnap", require: false

# Extensions
gem "shimmer"
gem "mini_magick"
gem "dotenv-rails"
gem "rails-i18n"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "kaminari"
gem "groupdate"
gem "bcrypt"
gem "friendly_id"
gem "countries", require: "countries/global"
gem "document_serializable"
gem "sitemap_generator"
gem "image_processing"
gem "slim-rails"
gem "pundit"
gem "yael"
gem "translate_client"

# Assets
gem "vite_rails"

# Scenario 1: Propshaft
# gem "propshaft"
# TODO: Understand why with `propshaft`, rending is abnormally slow.

# Scenario 2: What it was before attempting Propshaft
gem "jsbundling-rails"
gem "sassc-rails"
gem "autoprefixer-rails"

gem "stimulus-rails"
gem "turbo-rails"
gem "serviceworker-rails"


# Specific to the project (not from the template)
gem "closure_tree"
gem "devise"
gem "amazing_print" # awesome_print has bugs with some Rails classes
gem "table_print"
gem "money-rails"
gem "iban-tools"
gem "montrose"
gem "avo"
gem "ransack"

group :development, :test do
  gem "debug"
  gem "rspec-rails"
  gem "pry-rails"
  gem "pry-doc"
  gem "pry-byebug"
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "rack_session_access"
end

group :development do
  gem "listen"
  gem "web-console"
  gem "rb-fsevent"
  gem "letter_opener"
  gem "guard"
  gem "guard-rspec"
  gem "standard"
  gem "solargraph"
  gem "solargraph-standardrb"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rake"
  gem "i18n-tasks"
  gem "annotate"
  gem "chusaku", require: false
end
