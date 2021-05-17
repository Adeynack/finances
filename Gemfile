# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2" # <--> .github/workflows/tests.yml

# Core
gem "rails", "~> 6.1.3"
gem "puma", "~> 5.0"

# Database
gem "pg", "~> 1.1"
gem "redis", "~> 4.0"

# Model & ORM
gem "activerecord-pg_enum"
# gem "active_record_extended"
gem "friendly_id"
gem "pundit"

# Auth & Administration
gem "devise"

# Extensions
gem "slim"
gem "rails-i18n"
gem "bootsnap", ">= 1.4.4", require: false
gem "turbolinks", "~> 5"
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password
gem "awesome_print"
gem "kaminari"
gem "dotenv-rails"

# Jobs
gem "sidekiq"
gem "sidekiq-scheduler"

# Assets
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"

# Geography & Money
gem "countries"
gem "money", "~> 6.13.7"
gem "money-rails", "~> 1.13.3"
gem "iban-tools"

group :development, :test do
  # gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-doc" # ruby/3.0.0 isn't supported by this pry-doc version
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-performance", require: false
  gem "annotate", require: false
  gem "chusaku", require: false
  gem "i18n-tasks"
  gem "ruby_jard", git: "https://github.com/nguyenquangminh0711/ruby_jard"
  gem "bullet"
end

group :development do
  gem "web-console", ">= 4.1.0"
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  gem "spring"
  gem "guard"
  gem "guard-minitest"
end

group :test do
  gem "capybara", ">= 3.26" # Adds support for Capybara system testing and selenium driver
  gem "selenium-webdriver"
  gem "webdrivers" # Easy installation and use of web drivers to run system tests with browsers
  gem "minitest-focus"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
