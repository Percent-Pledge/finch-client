# frozen_string_literal: true

require 'finch/client/api'
require 'finch/client/version'
require 'finch/client/connect'
require 'finch/client/resource'
require 'finch/client/configuration'
require 'finch/client/resource_collection'

module Finch
  module Client
    extend self

    class Error < StandardError; end

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Finch::Client::Configuration.new
    end

    private

    def configuration=(configuration)
      @configuration = configuration
    end
  end
end
