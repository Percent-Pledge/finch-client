# frozen_string_literal: true

require 'base64'
require 'httparty'

module Finch
  module Client
    module Helpers
      def array_wrap(object)
        if object.nil?
          []
        elsif object.respond_to?(:to_ary)
          object.to_ary || [object]
        else
          [object]
        end
      end

      # This helps expose the logger to the API class
      def logger
        Finch::Client.configuration.logger
      end

      def deep_symbolize_keys(obj)
        case obj
        when Hash
          obj.each_with_object({}) do |(key, value), result|
            new_key = key.respond_to?(:to_sym) ? key.to_sym : key
            result[new_key] = deep_symbolize_keys(value)
          end
        when Array
          obj.map { |item| deep_symbolize_keys(item) }
        else
          obj
        end
      end
    end
  end
end
