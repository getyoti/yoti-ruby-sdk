# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedTextExtractionTask < RequestedTask
          #
          # @param [RequestedTextExtractionTaskConfig] config
          #
          def initialize(config)
            Validation.assert_is_a(
              RequestedTextExtractionTaskConfig,
              config,
              'config'
            )

            super(Constants::ID_DOCUMENT_TEXT_DATA_EXTRACTION, config)
          end

          #
          # @return [RequestedTextExtractionTaskBuilder]
          #
          def self.builder
            RequestedTextExtractionTaskBuilder.new
          end
        end

        #
        # The configuration applied when creating each TextExtractionTask
        #
        class RequestedTextExtractionTaskConfig
          #
          # @param [String] manual_check
          #   Describes the manual fallback behaviour applied to each Task
          # @param [String, nil] chip_data
          #   Describes the chip data requirement for each Task
          #
          def initialize(manual_check, chip_data)
            Validation.assert_is_a(String, manual_check, 'manual_check')
            @manual_check = manual_check

            Validation.assert_is_a(String, chip_data, 'chip_data', true)
            @chip_data = chip_data
          end

          def as_json(*_args)
            {
              manual_check: @manual_check,
              chip_data: @chip_data
            }.compact
          end
        end

        #
        # Builder to assist creation of {RequestedTextExtractionTask}
        #
        class RequestedTextExtractionTaskBuilder
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
          # The TextExtractionTask will never fallback to a manual TextDataCheck
          #
          # @return [self]
          #
          def with_manual_check_never
            @manual_check = Constants::NEVER
            self
          end

          #
          # @return [self]
          #
          def with_chip_data_desired
            @chip_data = Constants::DESIRED
            self
          end

          #
          # @return [self]
          #
          def with_chip_data_ignore
            @chip_data = Constants::IGNORE
            self
          end

          #
          # @return [RequestedTextExtractionTask]
          #
          def build
            config = RequestedTextExtractionTaskConfig.new(@manual_check, @chip_data)
            RequestedTextExtractionTask.new(config)
          end
        end
      end
    end
  end
end
