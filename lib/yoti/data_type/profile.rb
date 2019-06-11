module Yoti
  #
  # Encapsulates Yoti user profile
  #
  class Profile
    #
    # @param [Object] profile_data
    #
    def initialize(profile_data)
      profile_data = {} unless profile_data.is_a? Object
      @profile_data = profile_data
    end

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
    # Get attribute value by name.
    #
    # @param [String] attr_name
    #
    # @return [Attribute, nil]
    #
    def get_attribute(attr_name)
      return nil unless @profile_data.key? attr_name

      @profile_data[attr_name]
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
  end
end
