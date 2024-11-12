# frozen_string_literal: true

require 'base64'
require 'httparty'

module Finch
  module Client
    module Helpers
      # TODO: test
      def array_wrap(object)
        if object.nil?
          []
        elsif object.respond_to?(:to_ary)
          object.to_ary || [object]
        else
          [object]
        end
      end
    end
  end
end
