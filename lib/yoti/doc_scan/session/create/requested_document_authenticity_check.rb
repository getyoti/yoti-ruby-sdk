# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a Document Authenticity Check
        #
        class RequestedDocumentAuthenticityCheck < RequestedCheck
          def initialize(config)
            Validation.assert_is_a(
              RequestedDocumentAuthenticityCheckConfig,
              config,
              'config'
            )

            super(Constants::ID_DOCUMENT_AUTHENTICITY, config)
          end

          #
          # @return [RequestedDocumentAuthenticityCheckBuilder]
          #
          def self.builder
            RequestedDocumentAuthenticityCheckBuilder.new
          end
        end

        #
        # The configuration applied when creating a {RequestedDocumentAuthenticityCheck}
        #
        class RequestedDocumentAuthenticityCheckConfig
          def as_json(*_args)
            {}
          end
        end

        #
        # Builder to assist the creation of {RequestedDocumentAuthenticityCheck}
        #
        class RequestedDocumentAuthenticityCheckBuilder
          #
          # @return [RequestedDocumentAuthenticityCheck]
          #
          def build
            config = RequestedDocumentAuthenticityCheckConfig.new
            RequestedDocumentAuthenticityCheck.new(config)
          end
        end
      end
    end
  end
end
