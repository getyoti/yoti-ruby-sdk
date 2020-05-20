# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class TextExtractionTaskResponse < TaskResponse
          def generated_text_data_checks
            @generated_checks.select { |check| check.is_a?(GeneratedTextDataCheckResponse) }
          end
        end
      end
    end
  end
end
