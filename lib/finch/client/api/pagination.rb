# frozen_string_literal: true

module Finch
  module Client
    class API
      module Pagination
        # TODO: increase
        BATCH_SIZE = 25

        # TODO: doc and test
        def with_pagination(query_options)
          # If the user specifies any limit or offset, we assume they're acting intentionally
          should_paginate = query_options[:limit].nil? && query_options[:offset].nil?
          return yield(query_options) unless should_paginate

          result = ResourceCollection.new([])
          offset = 0
          limit = BATCH_SIZE

          loop do
            options = query_options.merge(offset: offset, limit: limit).compact
            response = yield(options)
            break if response.data.empty?

            result.merge(response)
            offset += BATCH_SIZE
          end

          result
        end
      end
    end
  end
end
