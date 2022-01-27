# frozen_string_literal: true

module Finch
  module Client
    class API
      module Payroll
        def payment(options = {})
          get('/employer/payment', { query: options })
        end

        def pay_statement(statement_requests)
          request_body = { requests: array_wrap(statement_requests) }.to_json

          post('/employer/pay-statement', { body: request_body }, 'responses')
        end
      end
    end
  end
end
