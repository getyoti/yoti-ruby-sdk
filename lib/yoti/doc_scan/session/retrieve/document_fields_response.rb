# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class DocumentFieldsResponse
          # @return [MediaResponse]
          attr_reader :media

          #
          # @param [Hash] document_fields
          #
          def initialize(document_fields)
            @media = MediaResponse.new(document_fields['media']) unless document_fields['media'].nil?
          end
        end
      end
    end
  end
end
