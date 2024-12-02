# frozen_string_literal: true

module Finch
  module Client
    class API
      module Organization
        def directory(options = {})
          with_pagination(options) do |query_options|
            get('/employer/directory', { query: query_options }, 'individuals')
          end
        end

        def company
          get('/employer/company')
        end

        def individual(individual_requests)
          with_batching(individual_requests) do |batch|
            post('/employer/individual', { body: batch }, 'responses')
          end
        end

        def employment(individual_requests)
          with_batching(individual_requests) do |batch|
            post('/employer/employment', { body: batch }, 'responses')
          end
        end
      end
    end
  end
end
