# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class DocumentFieldsResponse
          attr_reader :media

          def initialize(document_fields)
            @media = MediaResponse.new(document_fields['media']) unless document_fields['media'].nil?
          end
        end
      end
    end
  end
end
