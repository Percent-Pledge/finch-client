# frozen_string_literal: true

module Finch
  module Client
    class API
      module Management
        def introspect
          get('/introspect')
        end

        def providers
          get('/providers')
        end

        def disconnect
          post('/disconnect')
        end
      end
    end
  end
end
