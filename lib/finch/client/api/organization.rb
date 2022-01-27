# frozen_string_literal: true

module Finch
  module Client
    class API
      module Organization
        def directory
          get('/employer/directory', {}, 'individuals')
        end

        def company
          get('/employer/company')
        end
      end
    end
  end
end
