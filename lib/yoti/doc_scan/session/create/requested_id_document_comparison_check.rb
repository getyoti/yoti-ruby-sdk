# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of an ID Document Comparison Check
        #
        class RequestedIdDocumentComparisonCheck < RequestedCheck
          def initialize(config)
            Validation.assert_is_a(
              RequestedIdDocumentComparisonCheckConfig,
              config,
              'config'
            )

            super(Constants::ID_DOCUMENT_COMPARISON, config)
          end

          #
          # @return [RequestedIdDocumentComparisonCheckBuilder]
          #
          def self.builder
            RequestedIdDocumentComparisonCheckBuilder.new
          end
        end

        #
        # The configuration applied when creating a {RequestedIdDocumentComparisonCheck}
        #
        class RequestedIdDocumentComparisonCheckConfig
          def as_json(*_args)
            {}
          end
        end

        #
        # Builder to assist the creation of {RequestedIdDocumentComparisonCheck}
        #
        class RequestedIdDocumentComparisonCheckBuilder
          #
          # @return [RequestedIdDocumentComparisonCheck]
          #
          def build
            config = RequestedIdDocumentComparisonCheckConfig.new
            RequestedIdDocumentComparisonCheck.new(config)
          end
        end
      end
    end
  end
end
