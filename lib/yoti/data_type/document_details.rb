module Yoti
  class DocumentDetails
    #
    # @deprecated will be removed in 2.0.0 - pattern is no longer used for validation.
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
      parse_value(value)
    end

    private

    #
    # Parses provided value into separate attributes
    #
    # @param [String] value
    #
    def parse_value(value)
      attributes = value.split(/ /)
      raise(ArgumentError, "Invalid value for #{self.class.name}") if attributes.length < 3 || attributes.include?('')

      @type = attributes[TYPE_INDEX]
      @issuing_country = attributes[COUNTRY_INDEX]
      @document_number = attributes[NUMBER_INDEX]
      @expiration_date = parse_date_from_string(attributes[EXPIRATION_INDEX]) if attributes.length > 3
      @issuing_authority = attributes[AUTHORITY_INDEX] if attributes.length > 4
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
