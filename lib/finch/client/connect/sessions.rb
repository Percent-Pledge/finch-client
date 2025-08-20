# frozen_string_literal: true

require 'base64'
require 'httparty'

module Finch
  module Client
    class Connect
      class Sessions
        class SessionError < StandardError
          attr_reader :message, :error_name, :http_code, :finch_code

          def initialize(message, error_name: nil, http_code: nil, finch_code: nil)
            @message = message
            @error_name = error_name
            @http_code = http_code
            @finch_code = finch_code

            super(message)
          end
        end

        # TODO: test

        class << self
          def create(params, finch_api_version: '2020-09-17')
            do_create_session(params, finch_api_version)
              .then { |response| handle_response(response) }
          end

          def reauthenticate(params)
            do_reauthenticate(params)
              .then { |response| handle_response(response) }
          end

          private

          def do_create_session(params, finch_api_version)
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

          def do_reauthenticate(params)
            HTTParty.post(
              'https://api.tryfinch.com/connect/sessions/reauthenticate',
              headers: {
                'Authorization' => authorization_header,
                'Content-Type' => 'application/json'
              },
              body: params.to_json
            )
          end

          def handle_response(response)
            parsed_response = response.parsed_response

            if response.success?
              {
                session_id: parsed_response['session_id'],
                connect_url: parsed_response['connect_url']
              }
            else
              raise(SessionError.new(
                parsed_response['message'],
                error_name: parsed_response['name'],
                http_code: parsed_response['code'],
                finch_code: parsed_response['finch_code']
              ))
            end
          end

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
