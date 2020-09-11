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
          #
          # @param [String] manual_check
          #
          def initialize(manual_check)
            Validation.assert_is_a(String, manual_check, 'manual_check', true)
            @manual_check = manual_check
          end

          def as_json(*_args)
            {
              manual_check: @manual_check
            }.compact
          end
        end

        #
        # Builder to assist the creation of {RequestedDocumentAuthenticityCheck}
        #
        class RequestedDocumentAuthenticityCheckBuilder
          #
          # Requires that a manual follow-up check is always performed
          #
          # @return [self]
          #
          def with_manual_check_always
            @manual_check = Constants::ALWAYS
            self
          end

          #
          # Requires that a manual follow-up check is performed only on failed Checks,
          # and those with a low level of confidence
          #
          # @return [self]
          #
          def with_manual_check_fallback
            @manual_check = Constants::FALLBACK
            self
          end

          #
          # Requires that only an automated Check is performed.  No manual follow-up
          # Check will ever be initiated
          #
          # @return [self]
          #
          def with_manual_check_never
            @manual_check = Constants::NEVER
            self
          end

          #
          # @return [RequestedDocumentAuthenticityCheck]
          #
          def build
            config = RequestedDocumentAuthenticityCheckConfig.new(@manual_check)
            RequestedDocumentAuthenticityCheck.new(config)
          end
        end
      end
    end
  end
end
