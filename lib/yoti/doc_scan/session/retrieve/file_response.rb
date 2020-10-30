# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class FileResponse
          # @return [MediaResponse]
          attr_reader :media

          #
          # @param [Hash] file
          #
          def initialize(file)
            @media = MediaResponse.new(file['media']) unless file['media'].nil?
          end
        end
      end
    end
  end
end
