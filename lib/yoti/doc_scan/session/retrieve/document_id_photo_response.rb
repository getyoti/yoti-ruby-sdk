# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class DocumentIdPhotoResponse
          # @return [MediaResponse]
          attr_reader :media

          #
          # @param [Hash] document_id_photo
          #
          def initialize(document_id_photo)
            @media = MediaResponse.new(document_id_photo['media']) unless document_id_photo['media'].nil?
          end
        end
      end
    end
  end
end
