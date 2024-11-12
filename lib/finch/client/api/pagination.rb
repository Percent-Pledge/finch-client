# frozen_string_literal: true

module Finch
  module Client
    class API
      module Pagination
        BATCH_SIZE = 250
        MAX_SLEEP_SECONDS = 60
        BACKOFF_ALGORITHM = ->(n) { n**2 }
        # Arbitrary number to prevent infinite loops
        MAX_RATE_LIMIT_ERRORS = 25

        # Used to paginate responses from the Finch API.
        #
        # @param query_options [Hash] The query options to pass to the API request.
        #   NOTE: if the user specifies a limit or offset, pagination will not be applied.
        # @yield [query_options] The block to make the API request. `query_options` contains
        #   the appropriate `limit` and `offset` values.
        def with_pagination(query_options, &block)
          return yield(query_options) unless should_paginate?(query_options)

          result = ResourceCollection.new([])
          offset = 0

          loop do
            options = query_options.merge(offset: offset, limit: BATCH_SIZE).compact
            response = make_request_with_backoff(options, &block)
            break if response.data.empty?

            result.merge(response)
            offset += BATCH_SIZE
          end

          result
        end

        # Used to batch requests to the Finch API. This differs from
        # `with_pagination` in that it does not paginate the API requests but
        # instead turns splits batch requests to those API endpoints that support
        # them. This makes more requests to the API, but they should each finish
        # more quickly as to not run into an HTTP timeout
        #
        # @param request_objects [Array] The array of request objects to batch.
        # @yield [request_objects] The block to make the API request. `request_objects` contains
        #   the appropriate batch of requests to send to the API.
        def with_batching(request_objects, &block)
          result = ResourceCollection.new([])

          array_wrap(request_objects).each_slice(BATCH_SIZE) do |batch|
            response = make_request_with_backoff({ requests: batch }.to_json, &block)
            result.merge(response)
          end

          result
        end

        private

        # If the user specifies any limit or offset, we assume they're acting intentionally
        def should_paginate?(query_options)
          query_options[:limit].nil? && query_options[:offset].nil?
        end

        # TODO: add logging
        def make_request_with_backoff(*args)
          rate_limit_error_count = 0

          begin
            puts "Making request with args: #{args}"
            yield(*args)
          rescue APIError => e
            if e.response.code == 429 && rate_limit_error_count < MAX_RATE_LIMIT_ERRORS
              rate_limit_error_count += 1
              sleep_time = [BACKOFF_ALGORITHM.call(rate_limit_error_count), MAX_SLEEP_SECONDS].min

              puts "Rate limit error #{rate_limit_error_count} - sleeping for #{sleep_time} seconds"
              sleep(sleep_time)
              retry
            else
              raise e
            end
          end
        end
      end
    end
  end
end
