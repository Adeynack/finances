# frozen_string_literal: true

# TODO: SHIMMER
namespace :sidekiq do
  desc "Clears the Redis database used by Sidekiq"
  task clear: :environment do
    Sidekiq.redis(&:flushdb)
  end
end
