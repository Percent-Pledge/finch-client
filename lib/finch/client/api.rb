# frozen_string_literal: true

require 'logger'
require 'httparty'
require 'finch/client/api/connection'
require 'finch/client/api/pagination'

require 'finch/client/api/payroll'
require 'finch/client/api/benefits'
require 'finch/client/api/management'
require 'finch/client/api/organization'

module Finch
  module Client
    class API
      include HTTParty
      include Connection
      include Pagination

      include Payroll
      include Benefits
      include Management
      include Organization

      default_timeout 180

      base_uri 'https://api.tryfinch.com'
      format :json
      # TODO: remove
      # TODO: Add better logging app-wide. Maybe I don't need to remove, then?

      # logger ::Logger.new($stdout)

      def initialize(access_token)
        self.class.default_options.merge!(headers: {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => 'application/json',
          'Finch-API-Version' => '2020-09-17'
        })
      end

      private

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
