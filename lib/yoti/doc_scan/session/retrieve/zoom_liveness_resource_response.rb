# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class ZoomLivenessResourceResponse < LivenessResourceResponse
          attr_reader :facemap, :frames

          def initialize(resource)
            super(resource)

            @facemap = FaceMapResponse.new(resource['facemap']) unless resource['facemap'].nil?

            if resource['frames'].nil?
              @frames = []
            else
              Validation.assert_is_a(Array, resource['frames'], 'frames')
              @frames = resource['frames'].map { |frame| FrameResponse.new(frame) }
            end
          end
        end
      end
    end
  end
end
