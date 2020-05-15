# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedTextExtractionTask < RequestedTask
          def initialize(config)
            Validation.assert_is_a(
              RequestedTextExtractionTaskConfig,
              config,
              'config'
            )

            super(Constants::ID_DOCUMENT_TEXT_DATA_EXTRACTION, config)
          end

          def self.builder
            RequestedTextExtractionTaskBuilder.new
          end
        end

        class RequestedTextExtractionTaskConfig
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

        class RequestedTextExtractionTaskBuilder
          def with_manual_check_always
            @manual_check = Constants::ALWAYS
            self
          end

          def with_manual_check_fallback
            @manual_check = Constants::FALLBACK
            self
          end

          def with_manual_check_never
            @manual_check = Constants::NEVER
            self
          end

          def build
            config = RequestedTextExtractionTaskConfig.new(@manual_check)
            RequestedTextExtractionTask.new(config)
          end
        end
      end
    end
  end
end
