# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class FrameResponse
          attr_reader :media

          def initialize(frame)
            @media = MediaResponse.new(frame['media']) unless frame['media'].nil?
          end
        end
      end
    end
  end
end
