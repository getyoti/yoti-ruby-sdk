# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class PageResponse
          # @return [String]
          attr_reader :capture_method

          # @return [MediaResponse]
          attr_reader :media

          # @return [Array<FrameResponse>]
          attr_reader :frames

          #
          # @param [Hash] page
          #
          def initialize(page)
            Validation.assert_is_a(String, page['capture_method'], 'capture_method', true)
            @capture_method = page['capture_method']

            @media = MediaResponse.new(page['media']) unless page['media'].nil?

            if page['frames'].nil?
              @frames = []
            else
              Validation.assert_is_a(Array, page['frames'], 'frames')
              @frames = page['frames'].map { |frame| FrameResponse.new(frame) }
            end
          end
        end
      end
    end
  end
end
