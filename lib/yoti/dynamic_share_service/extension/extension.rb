# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class Extension
      # @return [String]
      attr_reader :type

      # @return [#to_json]
      attr_reader :content

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        {
          type: @type,
          content: @content
        }
      end

      def self.builder
        ExtensionBuilder.new
      end
    end

    class ExtensionBuilder
      def initialize
        @extension = Extension.new
      end

      def with_type(type)
        @extension.instance_variable_set(:@type, type)
        self
      end

      def with_content(content)
        @extension.instance_variable_set(:@content, content)
        self
      end

      def build
        Marshal.load Marshal.dump @extension
      end
    end
  end
end
