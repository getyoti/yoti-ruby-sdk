module Yoti
  # Encapsulates attribute anchor
  class Anchor
    attr_reader :value, :sub_type, :signed_time_stamp, :origin_server_certs

    def initialize(value, sub_type, signed_time_stamp, origin_server_certs)
      @value = value
      @sub_type = sub_type
      @signed_time_stamp = signed_time_stamp
      @origin_server_certs = origin_server_certs
    end
  end
end
