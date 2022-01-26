# frozen_string_literal: true

module Finch
  module Client
    class API
      module Organization
        def directory
          get('/directory')
        end
      end
    end
  end
end
