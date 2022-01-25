# frozen_string_literal: true

module Finch
  module Client
    class Configuration
      attr_writer :client_id, :client_secret, :sandbox

      def client_id
        @client_id || raise(ArgumentError, 'Finch client_id must be set')
      end

      def client_secret
        @client_secret || raise(ArgumentError, 'Finch client_secret must be set')
      end

      def sandbox
        @sandbox ||= false
      end
    end
  end
end
