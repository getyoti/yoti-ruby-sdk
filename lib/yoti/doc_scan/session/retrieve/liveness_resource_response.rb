# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class LivenessResourceResponse < ResourceResponse
          # @return [String]
          attr_reader :liveness_type

          #
          # @param [Hash] resource
          #
          def initialize(resource)
            super(resource)

            Validation.assert_is_a(String, resource['liveness_type'], 'liveness_type', true)
            @liveness_type = resource['liveness_type']
          end
        end
      end
    end
  end
end
