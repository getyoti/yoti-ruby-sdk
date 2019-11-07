# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class ThirdPartyAttributeExtension
      THIRD_PARTY_ATTRIBUTE = 'THIRD_PARTY_ATTRIBUTE'
      def initialize
        @expiry_date = nil
        @definitions = []
      end

      def with_expiry_date(expiry_date)
        @expiry_date = expiry_date
        self
      end

      def with_definitions(*names)
        names.each do |s|
          @definitions += [{ name: s }]
        end
        self
      end

      def as_json(*_args)
        {
          type: THIRD_PARTY_ATTRIBUTE,
          content: {
            expiry_date: @expiry_date,
            definitions: @definitions
          }
        }
      end

      def to_json(*_args)
        as_json.to_json
      end
    end
  end
end
