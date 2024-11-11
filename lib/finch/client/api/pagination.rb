# frozen_string_literal: true

module Finch
  module Client
    class API
      module Pagination
        # TODO: increase
        BATCH_SIZE = 25
        MAX_SLEEP_SECONDS = 60
        # Arbitrary number to prevent infinite loops
        MAX_RATE_LIMIT_ERRORS = 25

        # TODO: doc and test
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

        private

        # If the user specifies any limit or offset, we assume they're acting intentionally
        def should_paginate?(query_options)
          query_options[:limit].nil? && query_options[:offset].nil?
        end

        # TODO: add logging
        def make_request_with_backoff(options)
          rate_limit_error_count = 0

          begin
            puts "Making request with options: #{options}"
            yield(options)
          rescue APIError => e
            if e.response.code == 429 && rate_limit_error_count < MAX_RATE_LIMIT_ERRORS
              rate_limit_error_count += 1
              sleep_time = [rate_limit_error_count**2, MAX_SLEEP_SECONDS].min

              puts "Rate limit error #{rate_limit_error_count} - sleeping for #{sleep_time} seconds"
              sleep(rate_limit_error_count**2)
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
