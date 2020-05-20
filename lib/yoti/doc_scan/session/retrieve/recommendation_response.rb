# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class RecommendationResponse
          attr_reader :value, :reason, :recovery_suggestion

          def initialize(recommendation)
            Validation.assert_is_a(String, recommendation['value'], 'value', true)
            @value = recommendation['value']

            Validation.assert_is_a(String, recommendation['reason'], 'reason', true)
            @reason = recommendation['reason']

            Validation.assert_is_a(String, recommendation['recovery_suggestion'], 'recovery_suggestion', true)
            @recovery_suggestion = recommendation['recovery_suggestion']
          end
        end
      end
    end
  end
end
