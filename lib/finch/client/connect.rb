# frozen_string_literal: true

module Finch
  module Client
    class Connect
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

        private

        def sandbox_param
          if configuration.sandbox
            { sandbox: true }
          else
            {}
          end
        end

        def configuration
          Finch::Client.configuration
        end
      end
    end
  end
end
