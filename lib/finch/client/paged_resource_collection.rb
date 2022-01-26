# frozen_string_literal: true

module Finch
  module Client
    class PagedResourceCollection
      attr_reader :collection, :raw

      def initialize(data)
        @raw = data
        @collection = prepare_paged_resources(data)
      end

      private

      def prepare_paged_resources(data)
        data
      end
    end
  end
end
