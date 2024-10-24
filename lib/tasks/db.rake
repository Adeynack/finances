# frozen_string_literal: true

namespace :db do
  namespace :reset do
    desc "Perform a full reset of the database, loads seeds & fixtures, and re-annotate the models"
    task full: [:environment] do
      success = true
      [
        ["Drop Database", :rake, "db:drop"],
        ["Delete schema cache (schema.rb & structure.sql)", :sh, "rm -v -f db/schema.rb db/structure.sql"],
        ["Create Database", :rake, "db:create"],
        ["Migrate Database", :rake, "db:migrate"], # automatically annotate models
        ["Load Fixtures into Database", :rake, "db:fixtures:load"],
        ["Seed Database", :rake, "db:seed"]
      ].each do |title, type, command|
        puts title.blue + (success ? "" : " => Skipped because of previous error".yellow)
        case type
        when :rake
          puts "bin/rake #{command}"
          Rake::Task[command].invoke if success
        when :sh
          # `sh` outputs the command already
          sh command if success
        end
      rescue => e
        puts e.message.red
        success = false
      end
    end
  end
end
