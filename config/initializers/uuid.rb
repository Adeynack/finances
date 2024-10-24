# frozen_string_literal: true

# todo: keep either `uuid.rb` or `generators.rb`
Rails.application.configure do
  config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end
end
