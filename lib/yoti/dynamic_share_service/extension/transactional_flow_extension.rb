# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Extension for transactional flows
    class TransactionalFlowExtension
      EXTENSION_TYPE = 'TRANSACTIONAL_FLOW'

      # @return [#to_json]
      attr_reader :content

      # @return [String]
      attr_reader :type

      def initialize
        @type = EXTENSION_TYPE
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        {
          content: @content,
          type: @type
        }
      end

      def self.builder
        TransactionalFlowExtensionBuilder.new
      end
    end

    # Builder for TransactionalFlowExtension
    class TransactionalFlowExtensionBuilder
      def initialize
        @extension = TransactionalFlowExtension.new
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
