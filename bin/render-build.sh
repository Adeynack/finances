#!/usr/bin/env bash
# exit on error
set -o errexit

echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
env
echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
bin/rails runner 'puts ActiveRecord::Base.configurations.inspect'
echo "<><><><><><><><><><><><><><><><><><><><><><><><>"
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
