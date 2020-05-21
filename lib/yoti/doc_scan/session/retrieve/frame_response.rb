# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class FrameResponse
          # @return [MediaResponse]
          attr_reader :media

          #
          # @param [Hash] frame
          #
          def initialize(frame)
            @media = MediaResponse.new(frame['media']) unless frame['media'].nil?
          end
        end
      end
    end
  end
end
