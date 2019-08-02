module Yoti
  class DocumentDetails
    #
    # The values of the Document Details are in the format and order as defined in this pattern
    # e.g PASS_CARD GBR 22719564893 - CITIZENCARD, the last two are optionals
    #
    VALIDATION_PATTERN = '^([A-Za-z_]*) ([A-Za-z]{3}) ([A-Za-z0-9]{1}).*$'
    TYPE_INDEX = 0
    COUNTRY_INDEX = 1
    NUMBER_INDEX = 2
    EXPIRATION_INDEX = 3
    AUTHORITY_INDEX = 4

    #
    # Type of the document e.g. PASSPORT | DRIVING_LICENCE | NATIONAL_ID | PASS_CARD
    #
    # @return [String]
    #
    attr_reader :type

    #
    # ISO-3166-1 alpha-3 country code, e.g. "GBR"
    #
    # @return [String]
    #
    attr_reader :issuing_country

    #
    # Document number (may include letters) from the document.
    #
    # @return [String]
    #
    attr_reader :document_number

    #
    # Expiration date of the document in DateTime format. If the document does not expire, this
    # field will not be present. The time part of this DateTime will default to 00:00:00.
    #
    # @return [DateTime]
    #
    attr_reader :expiration_date

    #
    # Can either be a country code (for a state), or the name of the issuing authority.
    #
    # @return [String]
    #
    attr_reader :issuing_authority

    #
    # @param [String] value
    #
    def initialize(value)
      validate_value(value)
      parse_value(value)
    end

    private

    #
    # Asserts provided matches VALIDATION_PATTERN
    #
    # @param [String] value
    #
    def validate_value(value)
      raise(ArgumentError, "Invalid value for #{self.class.name}") unless /#{VALIDATION_PATTERN}/.match?(value)
    end

    #
    # Parses provided value into separate attributes
    #
    # @param [String] value
    #
    def parse_value(value)
      attributes = value.split(' ')
      @type = attributes[TYPE_INDEX]
      @issuing_country = attributes[COUNTRY_INDEX]
      @document_number = attributes[NUMBER_INDEX]
      @expiration_date = parse_date_from_string(attributes[EXPIRATION_INDEX])
      @issuing_authority = attributes[AUTHORITY_INDEX]
    end

    #
    # Converts provided date string into DateTime
    #
    # @param [String] date_string
    #
    # @return [DateTime]
    #
    def parse_date_from_string(date_string)
      return nil if date_string == '-'

      DateTime.iso8601(date_string)
    end
  end
end
