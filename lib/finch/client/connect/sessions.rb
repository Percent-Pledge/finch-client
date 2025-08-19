# frozen_string_literal: true

require 'base64'
require 'httparty'

module Finch
  module Client
    module Connect
      class Sessions
        class << self
          def create(params, finch_api_version: '2020-09-17')
            HTTParty.post(
              'https://api.tryfinch.com/connect/sessions',
              headers: {
                'Authorization' => authorization_header,
                'Content-Type' => 'application/json',
                'Finch-API-Version' => finch_api_version
              },
              body: params.to_json
            )
          end

          private

          def authorization_header
            "Basic #{Base64.strict_encode64("#{configuration.client_id}:#{configuration.client_secret}")}"
          end

          def configuration
            Finch::Client.configuration
          end
        end
      end
    end
  end
end
