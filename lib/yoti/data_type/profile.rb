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

      formatted_address
    end

    def structured_postal_address
      get_attribute(Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS)
    end

    # @return attribute value by name
    def get_attribute(attr_name)
      @profile_data[attr_name] if @profile_data.key? attr_name
    end

    protected

    def formatted_address
      return nil if structured_postal_address.nil?

      structured_postal_address['formatted_address'] if structured_postal_address.key?('formatted_address')
    end
  end
end
