require_relative 'base_profile'

module Yoti
  #
  # Encapsulates Yoti user profile
  #
  class Profile < BaseProfile
    #
    # Selfie is a photograph of the user.
    #
    # @return [Attribute, nil]
    #
    def selfie
      get_attribute(Yoti::Attribute::SELFIE)
    end

    #
    # Corresponds to primary name in passport, and surname in English.
    #
    # @return [Attribute, nil]
    #
    def family_name
      get_attribute(Yoti::Attribute::FAMILY_NAME)
    end

    #
    # Corresponds to secondary names in passport, and first/middle names in English.
    #
    # @return [Attribute, nil]
    #
    def given_names
      get_attribute(Yoti::Attribute::GIVEN_NAMES)
    end

    #
    # The user's full name.
    #
    # @return [Attribute, nil]
    #
    def full_name
      get_attribute(Yoti::Attribute::FULL_NAME)
    end

    #
    # The user's phone number, as verified at registration time. This will be a number with + for
    # international prefix and no spaces, e.g. "+447777123456".
    #
    # @return [Attribute, nil]
    #
    def phone_number
      get_attribute(Yoti::Attribute::PHONE_NUMBER)
    end

    #
    # The user's verified email address.
    #
    # @return [Attribute, nil]
    #
    def email_address
      get_attribute(Yoti::Attribute::EMAIL_ADDRESS)
    end

    #
    # Date of birth.
    #
    # @return [Attribute, nil]
    #
    def date_of_birth
      get_attribute(Yoti::Attribute::DATE_OF_BIRTH)
    end

    #
    # Corresponds to the gender in the passport; will be one of the strings
    # "MALE", "FEMALE", "TRANSGENDER" or "OTHER".
    #
    # @return [Attribute, nil]
    #
    def gender
      get_attribute(Yoti::Attribute::GENDER)
    end

    #
    # Corresponds to the nationality in the passport.
    #
    # @return [Attribute, nil]
    #
    def nationality
      get_attribute(Yoti::Attribute::NATIONALITY)
    end

    #
    # Document images.
    #
    # @return [Attribute, nil]
    #
    def document_images
      get_attribute(Yoti::Attribute::DOCUMENT_IMAGES)
    end

    #
    # The user's postal address as a String.
    #
    # @return [Attribute, nil]
    #
    def postal_address
      postal_address = get_attribute(Yoti::Attribute::POSTAL_ADDRESS)
      return postal_address unless postal_address.nil?

      attribute_from_formatted_address
    end

    #
    # The user's structured postal address as a JSON.
    #
    # @return [Attribute, nil]
    #
    def structured_postal_address
      get_attribute(Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS)
    end

    #
    # Document Details.
    #
    # @return [Attribute, nil]
    #
    def document_details
      get_attribute(Yoti::Attribute::DOCUMENT_DETAILS)
    end

    # Finds all the 'Age Over' and 'Age Under' derived attributes returned with the profile,
    # and returns them wrapped in AgeVerification objects
    #
    # @return [Array]
    #
    def age_verifications
      find_all_age_verifications
      @age_verifications.values
    end

    #
    # Searches for an AgeVerification corresponding to an 'Age Over' check for the given age
    #
    # @param [Integer] age
    #
    # @return [AgeVerification|nil]
    #
    def find_age_over_verification(age)
      find_age_verification(Yoti::Attribute::AGE_OVER, age)
    end

    #
    # Searches for an AgeVerification corresponding to an 'Age Under' check for the given age.
    #
    # @param [Integer] age
    #
    # @return [AgeVerification|nil]
    #
    def find_age_under_verification(age)
      find_age_verification(Yoti::Attribute::AGE_UNDER, age)
    end

    protected

    #
    # Creates attribute from formatted address.
    #
    # @return [Attribute, nil]
    #
    def attribute_from_formatted_address
      return nil if structured_postal_address.nil?
      return nil unless structured_postal_address.value.key?('formatted_address')

      Yoti::Attribute.new(
        Yoti::Attribute::POSTAL_ADDRESS,
        structured_postal_address.value['formatted_address'],
        structured_postal_address.sources,
        structured_postal_address.verifiers
      )
    end

    private

    #
    # Searches for an AgeVerification corresponding to provided type and age.
    #
    # @param [String] type
    # @param [Integer] age
    #
    # @return [Yoti::AgeVerification|nil]
    #
    def find_age_verification(type, age)
      raise(ArgumentError, "#{age} is not a valid age") unless age.is_a?(Integer)

      find_all_age_verifications
      @age_verifications[type + age.to_s] || nil
    end

    #
    # Find all age verifications and put in key value Hash.
    #
    def find_all_age_verifications
      return @age_verifications unless @age_verifications.nil?

      @age_verifications = {}

      find_attributes_starting_with(Yoti::Attribute::AGE_OVER).each do |_name, attribute|
        @age_verifications[attribute.name] = Yoti::AgeVerification.new(attribute)
      end
      find_attributes_starting_with(Yoti::Attribute::AGE_UNDER).each do |_name, attribute|
        @age_verifications[attribute.name] = Yoti::AgeVerification.new(attribute)
      end
    end
  end
end
