# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class ThirdPartyAttributeExtensionBuilder
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

      def build
        extension = ThirdPartyAttributeExtension.new
        extension.instance_variable_get(:@content)[:expiry_date] = @expiry_date
        extension.instance_variable_get(:@content)[:definitions] = @definitions
        extension
      end
    end

    class ThirdPartyAttributeExtension
      EXTENSION_TYPE = 'THIRD_PARTY_ATTRIBUTE'

      attr_reader :content
      attr_reader :type

      def initialize
        @content = {}
        @type = EXTENSION_TYPE
      end

      def as_json(*_args)
        {
          type: @type,
          content: @content
        }
      end

      def to_json(*_args)
        as_json.to_json
      end

      def self.builder
        ThirdPartyAttributeExtensionBuilder.new
      end
    end
  end
end
