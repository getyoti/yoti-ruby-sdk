# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class Extension
      attr_reader :type
      attr_reader :content

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
