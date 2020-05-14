# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class DocumentAuthenticityCheck < Check
          def initialize
            super(Yoti::DocScan::Constants::ID_DOCUMENT_AUTHENTICITY)
          end

          def self.builder
            DocumentAuthenticityCheckBuilder.new
          end
        end

        class DocumentAuthenticityCheckBuilder
          def build
            DocumentAuthenticityCheck.new
          end
        end
      end
    end
  end
end
