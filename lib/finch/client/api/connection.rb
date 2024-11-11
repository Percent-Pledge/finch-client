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

          if response.success?
            parse_response(response.parsed_response, response.headers, resource_key)
          else
            raise APIError.new(response.parsed_response['message'], response)
          end
        end

        def parse_response(data, headers, resource_key)
          data = data[resource_key] if resource_key

          case data
          when Hash then Resource.new(data, headers)
          when Array then ResourceCollection.new(data, headers)
          else raise(ArgumentError, "Unable to parse response - expected Hash or Array: #{data.inspect}")
          end
        end
      end
    end
  end
end
