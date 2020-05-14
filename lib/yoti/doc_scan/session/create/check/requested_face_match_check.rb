# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        module Check
          class RequestedFaceMatchCheck < RequestedCheck
            def initialize(config)
              super(Constants::ID_DOCUMENT_FACE_MATCH, config)
            end

            def self.builder
              RequestedFaceMatchCheckBuilder.new
            end
          end

          class RequestedFaceMatchCheckConfig
            def initialize(manual_check)
              @manual_check = manual_check
            end

            def as_json(*_args)
              {
                manual_check: @manual_check
              }
            end
          end

          class RequestedFaceMatchCheckBuilder
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
              config = RequestedFaceMatchCheckConfig.new(@manual_check)
              RequestedFaceMatchCheck.new(config)
            end
          end
        end
      end
    end
  end
end
