# frozen_string_literal: true

module Finch
  module Client
    class API
      class APIError < StandardError
        attr_reader :response

        def initialize(message, response)
          super(message)
          @response = response
        end
      end

      module Connection
        def get(path, options = {}, resource_key = nil)
          request(:get, path, options, resource_key)
        end

        def post(path, options = {}, resource_key = nil)
          request(:post, path, options, resource_key)
        end

        def delete(path, options = {}, resource_key = nil)
          request(:delete, path, options, resource_key)
        end

        private

        def request(http_method, path, options, resource_key)
          response = self.class.send(http_method, path, options)
          logging_context = {
            http_method: http_method.upcase,
            path: path,
            response_code: response.code,
            response_body: response.parsed_response,
            headers: response.headers
          }

          if response.success?
            logger.debug { "Finch API request successful. Context: #{logging_context}" }
            parse_response(response.parsed_response, response.headers, resource_key)
          else
            logger.error { "Finch API request failed. Context: #{logging_context}" }
            raise APIError.new(response.parsed_response['message'], response)
          end
        end

        def parse_response(response_body, headers, resource_key)
          data = resource_key ? response_body[resource_key] : response_body

          case data
          when Hash then Resource.new(data, headers, response_body)
          when Array then ResourceCollection.new(data, headers, response_body)
          else raise(ArgumentError, "Unable to parse response - expected Hash or Array: #{data.inspect}")
          end
        end
      end
    end
  end
end
