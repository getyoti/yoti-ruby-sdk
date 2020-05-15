# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedLivenessCheck < RequestedCheck
          def initialize(config)
            super(Constants::LIVENESS, config)
          end

          def self.builder
            RequestedLivenessCheckBuilder.new
          end
        end

        class RequestedLivenessCheckConfig
          def initialize(liveness_type, max_retries)
            @liveness_type = liveness_type
            @max_retries = max_retries
          end

          def as_json(*_args)
            {
              liveness_type: @liveness_type,
              max_retries: @max_retries
            }
          end
        end

        class RequestedLivenessCheckBuilder
          def for_liveness_type(liveness_type)
            @liveness_type = liveness_type
            self
          end

          def for_zoom_liveness
            for_liveness_type('ZOOM')
          end

          def with_max_retries(max_retries)
            @max_retries = max_retries
            self
          end

          def build
            config = RequestedLivenessCheckConfig.new(@liveness_type, @max_retries)
            RequestedLivenessCheck.new(config)
          end
        end
      end
    end
  end
end
