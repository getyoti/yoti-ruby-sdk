# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class FaceMapResponse
          attr_reader :media

          def initialize(facemap)
            @media = MediaResponse.new(facemap['media']) unless facemap['media'].nil?
          end
        end
      end
    end
  end
end
