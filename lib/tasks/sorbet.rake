# frozen_string_literal: true

namespace :sorbet do
  desc "Verify RBI files are up to date"
  task verify_rbis: :environment do
    puts "Checking if RBI files are up to date..."

    system("bin/tapioca gem --all --quiet") || abort("Failed to generate gem RBIs")
    system("bin/tapioca dsl --quiet") || abort("Failed to generate DSL RBIs")

    status = `git status --porcelain sorbet/rbi/`

    if status.strip.empty?
      puts "✓ RBI files are up to date"
    else
      puts "✗ RBI files are out of date. Run:"
      puts "  bin/tapioca gem --all"
      puts "  bin/tapioca dsl"
      puts "\nChanged files:"
      puts status
      abort("RBI files need to be regenerated")
    end
  end

  desc "Regenerate all RBI files"
  task regenerate: :environment do
    puts "Regenerating all RBI files..."
    system("bin/tapioca gem --all") || abort("Failed to generate gem RBIs")
    system("bin/tapioca dsl") || abort("Failed to generate DSL RBIs")
    puts "✓ RBI files regenerated"
  end

  desc "Run Sorbet type checker"
  task check: :environment do
    puts "Running Sorbet type checker..."
    system("bin/sorbet") || abort("Sorbet found type errors")
    puts "✓ No type errors"
  end
end
