# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class GeneratedCheckResponse
          # @return [String]
          attr_reader :id

          # @return [String]
          attr_reader :type

          #
          # @param [Hash] check
          #
          def initialize(check)
            Validation.assert_is_a(String, check['id'], 'id', true)
            @id = check['id']

            Validation.assert_is_a(String, check['type'], 'type', true)
            @type = check['type']
          end
        end
      end
    end
  end
end
