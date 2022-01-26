# frozen_string_literal: true

module Finch
  module Client
    class Resource
      attr_reader :data

      def self.from_array(array)
        array.map { |item| new(item) }
      end

      def initialize(data)
        @data = recursively_create_resources(data)
      end

      def method_missing(method_name, *arguments, &block)
        data[method_name] || super
      end

      def respond_to_missing?(method_name, include_private = false)
        data.keys.include?(method_name) || super
      end

      private

      def recursively_create_resources(data)
        data.each_with_object({}) do |(key, value), memo|
          memo[key.to_sym] =
            case value
            when Hash then Resource.new(value)
            when Array then value.map { |item| item.is_a?(Hash) ? Resource.new(item) : item }
            else value
            end
        end
      end
    end
  end
end
