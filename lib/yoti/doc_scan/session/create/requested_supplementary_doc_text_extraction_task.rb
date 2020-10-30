# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedSupplementaryDocTextExtractionTask < RequestedTask
          #
          # @param [RequestedSupplementaryDocTextExtractionTaskConfig] config
          #
          def initialize(config)
            Validation.assert_is_a(
              RequestedSupplementaryDocTextExtractionTaskConfig,
              config,
              'config'
            )

            super(Constants::SUPPLEMENTARY_DOCUMENT_TEXT_DATA_EXTRACTION, config)
          end

          #
          # @return [RequestedSupplementaryDocTextExtractionTaskBuilder]
          #
          def self.builder
            RequestedSupplementaryDocTextExtractionTaskBuilder.new
          end
        end

        #
        # The configuration applied when creating each SupplementaryDocTextExtractionTask
        #
        class RequestedSupplementaryDocTextExtractionTaskConfig
          #
          # @param [String] manual_check
          #   Describes the manual fallback behaviour applied to each Task
          #
          def initialize(manual_check)
            Validation.assert_is_a(String, manual_check, 'manual_check')
            @manual_check = manual_check
          end

          def as_json(*_args)
            {
              manual_check: @manual_check
            }.compact
          end
        end

        #
        # Builder to assist creation of {RequestedSupplementaryDocTextExtractionTask}
        #
        class RequestedSupplementaryDocTextExtractionTaskBuilder
          #
          # Requires that the Task is always followed by a manual TextDataCheck
          #
          # @return [self]
          #
          def with_manual_check_always
            @manual_check = Constants::ALWAYS
            self
          end

          #
          # Requires that only failed Tasks are followed by a manual TextDataCheck
          #
          # @return [self]
          #
          def with_manual_check_fallback
            @manual_check = Constants::FALLBACK
            self
          end

          #
          # The SupplementaryDocTextExtractionTask will never fallback to a manual TextDataCheck
          #
          # @return [self]
          #
          def with_manual_check_never
            @manual_check = Constants::NEVER
            self
          end

          #
          # @return [RequestedSupplementaryDocTextExtractionTask]
          #
          def build
            config = RequestedSupplementaryDocTextExtractionTaskConfig.new(@manual_check)
            RequestedSupplementaryDocTextExtractionTask.new(config)
          end
        end
      end
    end
  end
end
