# frozen_string_literal: true

clearing :on

guard :minitest, spring: "bin/rails test", all_on_start: false do
  # with Minitest::Unit
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$}) { "test" }
end
