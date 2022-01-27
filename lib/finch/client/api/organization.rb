# frozen_string_literal: true

module Finch
  module Client
    class API
      module Organization
        def directory(options = {})
          get('/employer/directory', { query: options }, 'individuals')
        end

        def company
          get('/employer/company')
        end

        def individual(individual_ids)
          formatted_ids = Array(individual_ids).map { |id| { individual_id: id.to_s } }
          request_body = { requests: formatted_ids }.to_json

          post('/employer/individual', { body: request_body }, 'responses')
        end

        def employment(individual_ids)
          formatted_ids = Array(individual_ids).map { |id| { individual_id: id.to_s } }
          request_body = { requests: formatted_ids }.to_json

          post('/employer/employment', { body: request_body }, 'responses')
        end
      end
    end
  end
end
