# frozen_string_literal: true

module Finch
  module Client
    class API
      include HTTParty
      base_uri 'https://api.tryfinch.com'
      format :json
    end
  end
end
