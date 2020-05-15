# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequestedDocumentAuthenticityCheck < RequestedCheck
          def initialize(config)
            super(Constants::ID_DOCUMENT_AUTHENTICITY, config)
          end

          def self.builder
            RequestedDocumentAuthenticityCheckBuilder.new
          end
        end

        class RequestedDocumentAuthenticityCheckConfig
          def as_json(*_args)
            {}
          end
        end

        class RequestedDocumentAuthenticityCheckBuilder
          def build
            config = RequestedDocumentAuthenticityCheckConfig.new
            RequestedDocumentAuthenticityCheck.new(config)
          end
        end
      end
    end
  end
end
