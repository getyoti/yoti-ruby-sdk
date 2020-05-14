# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class FaceMatchCheck < Check
          def initialize(config)
            super(Yoti::DocScan::Constants::ID_DOCUMENT_FACE_MATCH, config)
          end

          def self.builder
            FaceMatchCheckBuilder.new
          end
        end

        class FaceMatchCheckConfig
          def initialize(manual_check)
            @manual_check = manual_check
          end

          def as_json(*_args)
            {
              manual_check: @manual_check
            }
          end
        end

        class FaceMatchCheckBuilder
          def with_manual_check_always
            @manual_check = 'ALWAYS'
            self
          end

          def with_manual_check_fallback
            @manual_check = 'FALLBACK'
            self
          end

          def with_manual_check_never
            @manual_check = 'NEVER'
            self
          end

          def build
            config = FaceMatchCheckConfig.new(@manual_check)
            FaceMatchCheck.new(config)
          end
        end
      end
    end
  end
end
