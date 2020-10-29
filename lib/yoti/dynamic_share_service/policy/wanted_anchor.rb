# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # A wanted anchor for a source based constraint
    class WantedAnchor
      # @return [String]
      attr_reader :value

      # @return [String]
      attr_reader :sub_type

      def initialize
        @value = ''
        @sub_type = nil
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json
        obj = {
          name: @value
        }
        obj[:sub_type] = @sub_type if @sub_type
        obj
      end

      def self.builder
        WantedAnchorBuilder.new
      end
    end

    # Builder for WantedAnchor
    class WantedAnchorBuilder
      def initialize
        @anchor = WantedAnchor.new
      end

      def with_value(value)
        @anchor.instance_variable_set(:@value, value)
        self
      end

      def with_sub_type(sub_type = nil)
        @anchor.instance_variable_set(:@sub_type, sub_type)
        self
      end

      def build
        Marshal.load Marshal.dump @anchor
      end
    end
  end
end
