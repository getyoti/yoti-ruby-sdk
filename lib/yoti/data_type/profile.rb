module Yoti
  # Encapsulates Yoti user profile
  class Profile
    def initialize(profile_data)
      profile_data = {} unless profile_data.is_a? Object
      @profile_data = profile_data
    end

    def selfie
      get_attribute(Yoti::Attribute::SELFIE)
    end

    def family_name
      get_attribute(Yoti::Attribute::FAMILY_NAME)
    end

    def given_names
      get_attribute(Yoti::Attribute::GIVEN_NAMES)
    end

    def full_name
      get_attribute(Yoti::Attribute::FULL_NAME)
    end

    def phone_number
      get_attribute(Yoti::Attribute::PHONE_NUMBER)
    end

    def email_address
      get_attribute(Yoti::Attribute::EMAIL_ADDRESS)
    end

    def date_of_birth
      get_attribute(Yoti::Attribute::DATE_OF_BIRTH)
    end

    def gender
      get_attribute(Yoti::Attribute::GENDER)
    end

    def nationality
      get_attribute(Yoti::Attribute::NATIONALITY)
    end

    def postal_address
      postal_address = get_attribute(Yoti::Attribute::POSTAL_ADDRESS)
      return postal_address unless postal_address.nil?

      attribute_from_formatted_address
    end

    def structured_postal_address
      get_attribute(Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS)
    end

    # @return attribute value by name
    def get_attribute(attr_name)
      return nil unless @profile_data.key? attr_name

      @profile_data[attr_name]
    end

    protected

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
