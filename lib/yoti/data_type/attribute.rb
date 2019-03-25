module Yoti
  # Encapsulates profile attribute
  class Attribute
    FAMILY_NAME = 'family_name'
    GIVEN_NAMES = 'given_names'
    FULL_NAME = 'full_name'
    DATE_OF_BIRTH = 'date_of_birth'
    GENDER = 'gender'
    NATIONALITY = 'nationality'
    PHONE_NUMBER = 'phone_number'
    SELFIE = 'selfie'
    EMAIL_ADDRESS = 'email_address'
    POSTAL_ADDRESS = 'postal_address'
    STRUCTURED_POSTAL_ADDRESS = 'structured_postal_address'

    attr_reader :name, :value, :sources, :verifiers

    def initialize(name, value, sources, verifiers)
      @name = name
      @value = value
      @sources = sources
      @verifiers = verifiers
    end
  end
end
