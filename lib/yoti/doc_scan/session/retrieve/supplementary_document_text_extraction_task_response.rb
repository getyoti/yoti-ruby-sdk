# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class SupplementaryDocumentTextExtractionTaskResponse < TaskResponse
          #
          # @return [Array<GeneratedSupplementaryDocumentTextDataCheckResponse>]
          #
          def generated_text_data_checks
            @generated_checks.select { |check| check.is_a?(GeneratedSupplementaryDocumentTextDataCheckResponse) }
          end
        end
      end
    end
  end
end
