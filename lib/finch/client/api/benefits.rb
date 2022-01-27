# frozen_string_literal: true

module Finch
  module Client
    class API
      module Benefits
        def benefits
          get('/employer/benefits')
        end

        def benefit(benefit_id)
          get("/employer/benefits/#{benefit_id}")
        end

        def benefits_metadata
          get('/employer/benefits/meta')
        end

        def create_benefit(benefit_data)
          post('/employer/benefits', { body: benefit_data.to_json })
        end

        def update_benefit(benefit_id, benefit_data)
          post("/employer/benefits/#{benefit_id}", { body: benefit_data.to_json })
        end

        def benefit_enrolled_individuals(benefit_id)
          get("/employer/benefits/#{benefit_id}/enrolled")
        end

        def benefits_for_individual(benefit_id, individual_ids = nil)
          query_params = { individual_ids: array_wrap(individual_ids).join(',') }

          get("/employer/benefits/#{benefit_id}/individuals", { query: query_params })
        end

        def enroll_individual_in_benefit(benefit_id, enrollment_data)
          request_body = array_wrap(enrollment_data).to_json

          post("/employer/benefits/#{benefit_id}/individuals", { body: request_body })
        end

        def unenroll_individual_from_benefit(benefit_id, individual_ids)
          request_body = { individual_ids: array_wrap(individual_ids) }.to_json

          delete("/employer/benefits/#{benefit_id}/individuals", { body: request_body })
        end
      end
    end
  end
end
