# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a Face Match Check
        #
        class RequestedFaceMatchCheck < RequestedCheck
          #
          # @param [RequestedFaceMatchCheckConfig] config
          #
          def initialize(config)
            Validation.assert_is_a(
              RequestedFaceMatchCheckConfig,
              config,
              'config'
            )

            super(Constants::ID_DOCUMENT_FACE_MATCH, config)
          end

          #
          # @return [RequestedFaceMatchCheckBuilder]
          #
          def self.builder
            RequestedFaceMatchCheckBuilder.new
          end
        end

        #
        # The configuration applied when creating a {RequestedFaceMatchCheck}
        #
        class RequestedFaceMatchCheckConfig
          def initialize(manual_check)
            Validation.assert_not_nil(manual_check, 'manual_check')
            @manual_check = manual_check
          end

          def as_json(*_args)
            {
              manual_check: @manual_check
            }
          end
        end

        #
        # Builder to assist the creation of {RequestedFaceMatchCheck}
        #
        class RequestedFaceMatchCheckBuilder
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

          def build
            config = RequestedFaceMatchCheckConfig.new(@manual_check)
            RequestedFaceMatchCheck.new(config)
          end
        end
      end
    end
  end
end
