#!/usr/bin/env bash

# exit on error
set -o errexit

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> bundle install"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
bundle install

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> yarn build"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
# Weirdly enough, even though `assets:precompile` does call
# yarn build, the app fails to render if it's not called before.
yarn build

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> assets:precompile"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
bundle exec rake assets:precompile

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> assets:clean"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
bundle exec rake assets:clean

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> db:migrate"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
bundle exec rake db:migrate

echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "<> db:seed"
echo "<><><><><><><><><><><><><><><><><><><><><><><><><><><>"
if [ "$RAILS_PERFORM_SEED" == "1" ]; then bundle exec rake db:seed; fi
