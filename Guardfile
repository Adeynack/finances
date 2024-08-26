# frozen_string_literal: true

clearing :on

guard :rspec, cmd: "bin/rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  # watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
end
