# frozen_string_literal: true

namespace :db do
  namespace :reset do
    desc "Perform a full reset of the database, loads seeds & fixtures, and re-annotate the models"
    task full: [:environment] do
      steps = [
        ["Set Rails Environment to DEV", :sh, "rails db:environment:set RAILS_ENV=#{Rails.env}"],
        ["Drop Database", :rake, "db:drop"],
        ["Delete schema cache (schema.rb & structure.sql", :sh, "rm -v -f db/schema.rb db/structure.sql"],
        ["Create Database", :rake, "db:create"],
        ["Migrate Database", :rake, "db:migrate"],
        ["Annotate Models", :rake, "annotate_models"],
      ]
      steps << ["Seed Database", :rake, "db:seed"] if Rails.env.development?
      steps << ["Load Fixtures into Database", :rake, "db:fixtures:load"] if Rails.env.development?
      steps.each do |title, type, command|
        puts title.blue
        case type
        when :rake
          Rake::Task[command].invoke
        when :sh
          sh command
        end
      end
    end
  end
end
