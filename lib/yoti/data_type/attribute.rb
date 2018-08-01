module Yoti
  # Encapsulates profile attribute
  class Attribute
    attr_reader :name, :value, :sources, :verifiers

    def initialize(name, value, sources, verifiers)
        @name = name
        @value = value
        @sources = sources
        @verifiers = verifiers
    end
  end
end
