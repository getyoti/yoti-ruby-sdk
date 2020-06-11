# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class MediaResponse
          # @return [String]
          attr_reader :id

          # @return [String]
          attr_reader :type

          # @return [DateTime]
          attr_reader :created

          # @return [DateTime]
          attr_reader :last_updated

          #
          # @param [Hash] media
          #
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
