# frozen_string_literal: true

module MoneydanceImport
  class MoneydanceImport
    attr_reader :api_client

    def initialize(api_url:, api_token:)
      @api_client = Faraday.new(
        url: api_url,
        headers: {
          "Authorization" => api_token
        }
      )
    end
  end
end
