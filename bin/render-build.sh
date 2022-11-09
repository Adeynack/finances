#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

if [ "$RAILS_PERFORM_SEED" == "1" ]; then bundle exec rake db:seed; fi
