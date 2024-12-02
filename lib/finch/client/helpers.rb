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
    end
  end
end
