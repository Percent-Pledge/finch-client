# frozen_string_literal: true

module Finch
  module Client
    class ResourceCollection
      include Enumerable

      attr_reader :data, :raw_data, :raw_response, :headers

      def initialize(data, headers = nil, raw_response = nil)
        @raw_data = data
        @raw_response = raw_response
        @data = data.map { |item| item.is_a?(Hash) ? Resource.new(item, headers) : item }
        @headers = [headers].compact
      end

      # For satisfying the Enumerable interface
      def each(&block)
        data.each(&block)
      end

      def merge(other)
        @headers += other.headers
        @raw_data += other.raw_data
        @data += other.data

        self
      end
    end
  end
end
