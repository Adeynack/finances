#!/usr/bin/env bash
# exit on error
set -o errexit

# bundle install
# bundle exec rake assets:precompile
# bundle exec rake assets:clean
echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
echo "DATABASE_URL:"
echo $DATABASE_URL
echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
echo "RAILS_ENV:"
echo $RAILS_ENV
echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
# bundle exec rake db:migrate
