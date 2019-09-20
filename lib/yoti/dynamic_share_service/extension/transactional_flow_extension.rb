# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Extension for transactional flows
    class TransactionalFlowExtension
      EXTENSION_TYPE = 'TRANSACTIONAL_FLOW'
      attr_reader :content
      attr_reader :type

      def initialize
        @type = EXTENSION_TYPE
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
