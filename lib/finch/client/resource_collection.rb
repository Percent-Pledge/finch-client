# frozen_string_literal: true

module Finch
  module Client
    class ResourceCollection
      include Enumerable

      attr_reader :data, :raw_data, :headers

      def initialize(data, headers = {})
        @raw_data = data
        @data = data.map { |item| item.is_a?(Hash) ? Resource.new(item, headers) : item }
        @headers = headers
      end

      # For satisfying the Enumerable interface
      def each(&block)
        data.each(&block)
      end
    end
  end
end
