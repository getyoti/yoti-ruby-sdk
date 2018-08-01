module Yoti
  # Encapsulates profile attribute
  class Anchor
    attr_reader :value, :subType, :signedTimeStamp, :originServerCerts

    def initialize(value, subType, signedTimeStamp, originServerCerts)
        @value = value
        @subType = subType
        @signedTimeStamp = signedTimeStamp
        @originServerCerts = originServerCerts
    end
  end
end