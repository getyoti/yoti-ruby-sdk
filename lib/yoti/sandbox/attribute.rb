# frozen_string_literal: true

module Sandbox
  # Attribute describes an attribute on a sandbox profile
  class Attribute
    attr_accessor :name
    attr_accessor :value
    attr_accessor :derivation
    attr_accessor :optional
    attr_reader :anchors

    def initialize(
      name: '',
      value: '',
      derivation: '',
      optional: false,
      anchors: []
    )
      @name = name
      @value = value
      @derivation = derivation
      @optional = optional
      @anchors = anchors
    end

    def as_json(*_args)
      {
        name: name,
        value: value,
        derivation: derivation,
        optional: optional,
        anchors: anchors
      }
    end

    def add_anchor(anchor)
      @anchors.push anchor
      nil
    end
  end

  # Helper functions for building derivation strings
  module Derivation
    def self.age_over(age)
      "age_over:#{age}"
    end

    def self.age_under(age)
      "age_under:#{age}"
    end
  end
end
