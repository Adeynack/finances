source "https://rubygems.org"
ruby File.read(".ruby-version").strip

# Core
gem "rails", "~> 7.0.2"
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
gem "jsbundling-rails"
gem "stimulus-rails"
gem "sassc-rails"
gem "autoprefixer-rails"
gem "turbo-rails"
gem "serviceworker-rails"

# Specific to the project (not from the template)
gem "closure_tree"
gem "devise"
gem "awesome_print"
gem "table_print"
gem "money-rails", "~> 1.13.3"
gem "iban-tools"
gem "montrose"

group :development, :test do
  gem "rspec-rails"
  gem "standard"
  gem "capybara"
  gem "cuprite"
  gem "i18n-tasks", "0.9.35"
  gem "rack_session_access"
  gem "annotate"
  gem "chusaku", require: false
end

group :development do
  gem "listen"
  gem "web-console"
  gem "rb-fsevent"
  gem "letter_opener"
  gem "debug"
  gem "pry-rails"
  gem "guard"
  gem "guard-rspec"
  gem "solargraph-standardrb"
end
