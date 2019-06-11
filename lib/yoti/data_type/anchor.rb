module Yoti
  # Encapsulates attribute anchor
  class Anchor
    #
    # Gets the value of the given anchor.
    #
    # Among possible options for SOURCE are "USER_PROVIDED", "PASSPORT",
    # "DRIVING_LICENCE", "NATIONAL_ID" and "PASSCARD".
    #
    # Among possible options for VERIFIER are "YOTI_ADMIN", "YOTI_IDENTITY",
    # "YOTI_OTP", "PASSPORT_NFC_SIGNATURE", "ISSUING_AUTHORITY" and
    # "ISSUING_AUTHORITY_PKI".
    #
    # @return [String]
    #
    attr_reader :value

    #
    # SubType is an indicator of any specific processing method, or subcategory,
    # pertaining to an artifact.
    #
    # Examples:
    # - For a passport, this would be either "NFC" or "OCR".
    # - For a national ID, this could be "AADHAAR".
    #
    # @return [String]
    #
    attr_reader :sub_type

    #
    # Timestamp applied at the time of Anchor creation.
    #
    # @return [Yoti::SignedTimeStamp]
    #
    attr_reader :signed_time_stamp

    #
    # Certificate chain generated when this Anchor was created (attribute value was
    # sourced or verified). Securely encodes the Anchor type and value.
    #
    # @return [Array<OpenSSL::X509::Certificate>]
    #
    attr_reader :origin_server_certs

    def initialize(value, sub_type, signed_time_stamp, origin_server_certs)
      @value = value
      @sub_type = sub_type
      @signed_time_stamp = signed_time_stamp
      @origin_server_certs = origin_server_certs
    end
  end
end
