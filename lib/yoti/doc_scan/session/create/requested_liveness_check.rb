# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Requests creation of a Liveness Check
        #
        class RequestedLivenessCheck < RequestedCheck
          #
          # @param [RequestedLivenessCheckConfig] config
          #
          def initialize(config)
            Validation.assert_is_a(
              RequestedLivenessCheckConfig,
              config,
              'config'
            )

            super(Constants::LIVENESS, config)
          end

          #
          # @return [RequestedLivenessCheckBuilder]
          #
          def self.builder
            RequestedLivenessCheckBuilder.new
          end
        end

        #
        # The configuration applied when creating a {RequestedLivenessCheck}
        #
        class RequestedLivenessCheckConfig
          #
          # @param [String] liveness_type
          # @param [String] max_retries
          #
          def initialize(liveness_type, max_retries)
            Validation.assert_is_a(String, liveness_type, 'liveness_type')
            @liveness_type = liveness_type

            Validation.assert_is_a(Integer, max_retries, 'max_retries')
            @max_retries = max_retries
          end

          def as_json(*_args)
            {
              liveness_type: @liveness_type,
              max_retries: @max_retries
            }
          end
        end

        #
        # Builder to assist the creation of {RequestedLivenessCheck}
        #
        class RequestedLivenessCheckBuilder
          def initialize
            @max_retries = 1
          end

          #
          # Sets the type of the liveness check to the supplied value
          #
          # @param [String] liveness_type
          #
          # @return [self]
          #
          def for_liveness_type(liveness_type)
            @liveness_type = liveness_type
            self
          end

          #
          # Sets the type to be of a ZOOM liveness check
          #
          # @return [self]
          #
          def for_zoom_liveness
            for_liveness_type(Constants::ZOOM)
          end

          #
          # Sets the maximum number of retries allowed by the user
          #
          # @param [Integer] max_retries
          #
          # @return [self]
          #
          def with_max_retries(max_retries)
            @max_retries = max_retries
            self
          end

          #
          # @return [RequestedLivenessCheck]
          #
          def build
            config = RequestedLivenessCheckConfig.new(@liveness_type, @max_retries)
            RequestedLivenessCheck.new(config)
          end
        end
      end
    end
  end
end
