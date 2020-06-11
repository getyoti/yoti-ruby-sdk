# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class GeneratedMedia
          # @return [String]
          attr_reader :id

          # @return [String]
          attr_reader :type

          #
          # @param [Hash] media
          #
          def initialize(media)
            Validation.assert_is_a(String, media['id'], 'id', true)
            @id = media['id']

            Validation.assert_is_a(String, media['type'], 'type', true)
            @type = media['type']
          end
        end
      end
    end
  end
end
