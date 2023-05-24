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

# Jobs
gem "sidekiq"
gem "sidekiq-scheduler"

# Extensions
gem "shimmer"
gem "dotenv-rails"
gem "rails-i18n"
gem "pundit"
gem "yael"

# Images
gem "mini_magick"
gem "image_processing"

# Data
gem "bcrypt"
gem "countries", require: "countries/global"
gem "groupdate"
gem "friendly_id"
gem "closure_tree"
gem "money-rails"
gem "iban-tools"
gem "montrose"

# Console Helpers
gem "awesome_print"
gem "table_print"

group :development, :test do
  # Debugging
  gem "debug"
  gem "pry-doc"
  gem "pry-byebug"
  gem "pry-rails"

  # Tests
  gem "rspec-rails"
  gem "rspec-retry"
  gem "rack_session_access"
end

group :development do
  gem "listen"
  gem "web-console"
  gem "rb-fsevent"
  gem "letter_opener"
  gem "guard"
  gem "guard-rspec"
  gem "solargraph"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-rake"
  gem "annotate"
  gem "standard"
  gem "i18n-tasks"
  gem "chusaku", require: false
end
