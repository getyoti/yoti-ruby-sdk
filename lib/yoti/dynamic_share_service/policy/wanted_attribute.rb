# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Describes a wanted attribute in a dynamic sharing policy
    class WantedAttribute
      attr_reader :name
      attr_reader :derivation

      def accept_self_asserted
        return true if @accept_self_asserted

        false
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        obj = {
          name: @name
        }
        obj[:derivation] = @derivation if derivation
        obj[:accept_self_asserted] = @accept_self_asserted if accept_self_asserted
        obj
      end

      def self.builder
        WantedAttributeBuilder.new
      end
    end

    # Builder for WantedAttribute
    class WantedAttributeBuilder
      def initialize
        @attribute = WantedAttribute.new
      end

      def with_name(name)
        @attribute.instance_variable_set(:@name, name)
        self
      end

      def with_derivation(derivation)
        @attribute.instance_variable_set(:@derivation, derivation)
        self
      end

      def with_accept_self_asserted(accept = true)
        @attribute.instance_variable_set(:@accept_self_asserted, accept)
        self
      end

      def build
        Marshal.load Marshal.dump @attribute
      end
    end
  end
end
