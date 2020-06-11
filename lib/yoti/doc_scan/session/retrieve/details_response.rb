# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class DetailsResponse
          # @return [String]
          attr_reader :name

          # @return [String]
          attr_reader :value

          #
          # @param [Hash] details
          #
          def initialize(details)
            Validation.assert_is_a(String, details['name'], 'name', true)
            @name = details['name']

            Validation.assert_is_a(String, details['value'], 'value', true)
            @value = details['value']
          end
        end
      end
    end
  end
end
