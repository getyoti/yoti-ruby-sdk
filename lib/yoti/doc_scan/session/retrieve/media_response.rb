# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class MediaResponse
          attr_reader :id, :type, :created, :last_updated

          def initialize(media)
            Validation.assert_is_a(String, media['id'], 'id', true)
            @id = media['id']

            Validation.assert_is_a(String, media['type'], 'type', true)
            @type = media['type']

            @created = DateTime.parse(media['created']) unless media['created'].nil?

            @last_updated = DateTime.parse(media['last_updated']) unless media['last_updated'].nil?
          end
        end
      end
    end
  end
end
