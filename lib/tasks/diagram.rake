# frozen_string_literal: true

namespace :diagram do
  desc "Generate a MermaidJS ER diagram from Rails models"
  task mermaid: :environment do
    require "active_support/inflector"

    models = Dir[Rails.root.join("app/models/**/*.rb")].filter_map do |file|
      model_name = File.basename(file, ".rb").camelize
      begin
        model = model_name.constantize
        model if model < ApplicationRecord
      rescue
        nil
      end
    end

    lines = [
      "```mermaid",
      "erDiagram"
    ]

    models.each do |model|
      table = model.table_name
      # Add fields (optional, here just id for brevity)
      lines << "  #{table} {"
      lines << "    UUID id"
      lines << "  }"
    end

    # Example: {"users" => ["api_sessions", "books"]}
    one_to_many = {}

    models.each do |model|
      table = model.table_name
      next if table.ends_with?("_hierarchies")

      model.reflect_on_all_associations.each do |assoc|
        target = begin
          assoc.klass.table_name
        rescue
          next
        end
        next if target.ends_with?("_hierarchies")

        next if one_to_many[table]&.include?(target)
        one_to_many[target] ||= []

        case assoc.macro
        when :belongs_to
          lines << "  #{table} }o--|| #{target} : belongs_to"
          one_to_many[target] << table
        when :has_many
          lines << "  #{table} ||--o{ #{target} : has_many"
          one_to_many[target] << table
        when :has_one
          lines << "  #{table} ||--|| #{target} : has_one"
        end
      end
    end

    lines << "```"

    File.write(Rails.root.join("tmp/mermaid_er_diagram.md"), lines.join("\n"))
    puts "MermaidJS ER diagram written to tmp/mermaid_er_diagram.md"
  end
end
