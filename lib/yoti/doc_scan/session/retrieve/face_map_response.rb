# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class FaceMapResponse
          # @return [MediaResponse]
          attr_reader :media

          #
          # @param [Hash] facemap
          #
          def initialize(facemap)
            @media = MediaResponse.new(facemap['media']) unless facemap['media'].nil?
          end
        end
      end
    end
  end
end
