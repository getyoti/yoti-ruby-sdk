# frozen_string_literal: true

module Sandbox
  # Anchor describes an anchor on a Sandbox Attribute
  class Anchor
    attr_reader :type
    attr_reader :value
    attr_reader :sub_type
    attr_reader :timestamp

    def initialize(type:, value:, sub_type: '', timestamp: Time.now)
      @type = type
      @value = value
      @sub_type = sub_type
      @timestamp = timestamp
    end

    def as_json(*_args)
      {
        type: @type,
        value: @value,
        sub_type: @sub_type,
        timestamp: @timestamp.to_i
      }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

    def self.source(value, sub_type: '', timestamp: Time.now)
      Anchor.new(
        type: 'SOURCE',
        value: value,
        sub_type: sub_type,
        timestamp: timestamp
      )
    end

    def self.verifier(value, sub_type: '', timestamp: Time.now)
      Anchor.new(
        type: 'VERIFIER',
        value: value,
        sub_type: sub_type,
        timestamp: timestamp
      )
    end
  end
end
