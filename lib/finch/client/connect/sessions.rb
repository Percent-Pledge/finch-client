# frozen_string_literal: true

require 'base64'
require 'httparty'

module Finch
  module Client
    class Connect
      class Sessions
        class SessionError < StandardError
          attr_reader :message, :error_name, :code

          def initialize(message, error_name: nil, code: nil)
            @message = message
            @error_name = error_name
            @code = code
            super(message)
          end
        end

        # TODO: test

        class << self
          def create(params, finch_api_version: '2020-09-17')
            response = do_create_session(params, finch_api_version)
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
                code: parsed_response['code']
              ))
            end
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
