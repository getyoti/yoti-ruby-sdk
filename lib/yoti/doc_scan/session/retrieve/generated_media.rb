# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class GeneratedMedia
          attr_reader :id, :type

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
