# frozen_string_literal: true

module Yoti
  class Validation
    #
    # @param value
    # @param [String] name
    #
    def self.assert_not_nil(value, name)
      return unless value.nil?

      raise(ArgumentError, "#{name} must not be nil")
    end

    #
    # @param [Class] type
    # @param value
    # @param [String] name
    # @param [Boolean] nilable
    #
    def self.assert_is_a(type, value, name, nilable = false)
      return if nilable && value.nil?
      return if value.is_a?(type)

      raise(ArgumentError, "#{name} must be a #{type.name}")
    end

    #
    # @param [Symbol] method
    # @param value
    # @param [String] name
    #
    def self.assert_respond_to(method, value, name)
      assert_not_nil(value, name)

      return if value.respond_to?(method)

      raise(ArgumentError, "#{name} must respond to #{method}")
    end
  end
end
