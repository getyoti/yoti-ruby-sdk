module Yoti
  # Encapsulates profile attribute
  class Attribute
    FAMILY_NAME = 'family_name'.freeze
    GIVEN_NAMES = 'given_names'.freeze
    FULL_NAME = 'full_name'.freeze
    DATE_OF_BIRTH = 'date_of_birth'.freeze
    GENDER = 'gender'.freeze
    NATIONALITY = 'nationality'.freeze
    PHONE_NUMBER = 'phone_number'.freeze
    SELFIE = 'selfie'.freeze
    EMAIL_ADDRESS = 'email_address'.freeze
    POSTAL_ADDRESS = 'postal_address'.freeze
    STRUCTURED_POSTAL_ADDRESS = 'structured_postal_address'.freeze

    attr_reader :name, :value, :sources, :verifiers

    def initialize(name, value, sources, verifiers)
      @name = name
      @value = value
      @sources = sources
      @verifiers = verifiers
    end
  end
end
