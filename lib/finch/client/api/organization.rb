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
          request_body = { requests: array_wrap(individual_requests) }.to_json

          post('/employer/individual', { body: request_body }, 'responses')
        end

        def employment(individual_requests)
          request_body = { requests: array_wrap(individual_requests) }.to_json

          post('/employer/employment', { body: request_body }, 'responses')
        end
      end
    end
  end
end
