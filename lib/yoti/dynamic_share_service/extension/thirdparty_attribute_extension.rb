# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class ThirdPartyAttributeDefinition
      #
      # @param [String] name
      #
      def initialize(name)
        @name = name
      end

      def to_json(*_args)
        { name: @name }.to_json
      end
    end

    class ThirdPartyAttributeExtensionBuilder
      def initialize
        @expiry_date = nil
        @definitions = []
      end

      #
      # @param [DateTime] expiry_date
      #
      # @return [self]
      #
      def with_expiry_date(expiry_date)
        @expiry_date = expiry_date
        self
      end

      #
      # @param [String] *names
      #
      # @return [self]
      #
      def with_definitions(*names)
        @definitions += names.map do |name|
          ThirdPartyAttributeDefinition.new(name)
        end
        self
      end

      #
      # @return [ThirdPartyAttributeExtension]
      #
      def build
        content = ThirdPartyAttributeExtensionContent.new(@expiry_date, @definitions)
        ThirdPartyAttributeExtension.new(content)
      end
    end

    class ThirdPartyAttributeExtension
      EXTENSION_TYPE = 'THIRD_PARTY_ATTRIBUTE'

      # @return [ThirdPartyAttributeExtensionContent]
      attr_reader :content

      # @return [String]
      attr_reader :type

      #
      # @param [ThirdPartyAttributeExtensionContent] content
      #
      def initialize(content = nil)
        @content = content
        @type = EXTENSION_TYPE
      end

      def as_json(*_args)
        json = {}
        json[:type] = @type
        json[:content] = @content.as_json unless @content.nil?
        json
      end

      def to_json(*_args)
        as_json.to_json
      end

      #
      # @return [ThirdPartyAttributeExtensionBuilder]
      #
      def self.builder
        ThirdPartyAttributeExtensionBuilder.new
      end
    end

    class ThirdPartyAttributeExtensionContent
      #
      # @param [DateTime] expiry_date
      # @param [Array<ThirdPartyAttributeDefinition>] definitions
      #
      def initialize(expiry_date, definitions)
        @expiry_date = expiry_date
        @definitions = definitions
      end

      def as_json(*_args)
        json = {}
        json[:expiry_date] = @expiry_date.utc.rfc3339(3) unless @expiry_date.nil?
        json[:definitions] = @definitions
        json
      end

      def to_json(*_args)
        as_json.to_json
      end
    end
  end
end
