# frozen_string_literal: true

module Finch
  module Client
    class API
      class APIError < StandardError; end

      module Connection
        def get(path, options = {}, resource_key = nil)
          request(:get, path, options, resource_key)
        end

        def post(path, options = {}, resource_key = nil)
          request(:post, path, options, resource_key)
        end

        private

        def request(http_method, path, options, resource_key)
          response = self.class.send(http_method, path, options)

          if response.success?
            parse_response(response.parsed_response, resource_key)
          else
            raise APIError, response.parsed_response['message']
          end
        end

        def parse_response(data, resource_key)
          data = resource_key ? data[resource_key] : data

          case data
          when Hash then Resource.new(data)
          when Array then data.map { |item| item.is_a?(Hash) ? Resource.new(item) : item }
          else raise(ArgumentError, "Unable to parse response - expected Hash or Array: #{data.inspect}")
          end
        end
      end
    end
  end
end
