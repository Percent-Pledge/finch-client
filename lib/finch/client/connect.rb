# frozen_string_literal: true

require 'httparty'

module Finch
  module Client
    class Connect
      class AccessTokenError < StandardError; end

      class << self
        def authorization_uri(redirect_uri, products, optional_params = {})
          URI::HTTPS.build(
            host: 'connect.tryfinch.com',
            path: '/authorize',
            query: URI.encode_www_form({
              redirect_uri: redirect_uri,
              products: products,
              client_id: configuration.client_id
            }.merge(optional_params).merge(sandbox_param))
          )
        end

        def request_access_token(code, redirect_uri)
          response = do_request_access_token(code, redirect_uri)

          if response.success?
            response.parsed_response
          else
            raise AccessTokenError, response.parsed_response['message']
          end
        end

        private

        def sandbox_param
          if configuration.sandbox
            { sandbox: true }
          else
            {}
          end
        end

        def do_request_access_token(code, redirect_uri)
          HTTParty.post(
            'https://api.tryfinch.com/auth/token',
            headers: {
              'Authorization' => authorization_header
            },
            body: {
              code: code,
              redirect_uri: redirect_uri
            }
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
