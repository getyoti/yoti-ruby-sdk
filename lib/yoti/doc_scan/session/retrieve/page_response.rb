# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class PageResponse
          attr_reader :capture_method, :media

          def initialize(page)
            Validation.assert_is_a(String, page['capture_method'], 'capture_method', true)
            @capture_method = page['capture_method']

            @media = MediaResponse.new(page['media']) unless page['media'].nil?
          end
        end
      end
    end
  end
end
