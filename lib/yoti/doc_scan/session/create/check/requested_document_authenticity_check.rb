# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        module Check
          class RequestedDocumentAuthenticityCheck < RequestedCheck
            def initialize
              super(Constants::ID_DOCUMENT_AUTHENTICITY)
            end

            def self.builder
              RequestedDocumentAuthenticityCheckBuilder.new
            end
          end

          class RequestedDocumentAuthenticityCheckBuilder
            def build
              RequestedDocumentAuthenticityCheck.new
            end
          end
        end
      end
    end
  end
end
