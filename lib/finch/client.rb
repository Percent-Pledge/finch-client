# frozen_string_literal: true

require 'finch/client/version'
require 'finch/client/configuration'

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
