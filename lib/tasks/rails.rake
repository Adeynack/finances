# frozen_string_literal: true

# Workaround for making annotate_routes work
# https://github.com/ctran/annotate_models/issues/845#issuecomment-833193658
task routes: :environment do
  puts `bundle exec rails routes`
end
