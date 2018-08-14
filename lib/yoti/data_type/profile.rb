module Yoti
  # Encapsulates Yoti user profile
  class Profile

    def initialize(profile_data)
        if !profile_data.is_a? Object
            profile_data = Hash.new
        end
        @profile_data = profile_data
    end

    def selfie
        return get_attribute(Yoti::Attribute::SELFIE)
    end

    def family_name
        return get_attribute(Yoti::Attribute::FAMILY_NAME)
    end

    def given_names
        return get_attribute(Yoti::Attribute::GIVEN_NAMES)
    end

    def full_name
        return get_attribute(Yoti::Attribute::FULL_NAME)
    end

    def phone_number
        return get_attribute(Yoti::Attribute::PHONE_NUMBER)
    end

    def email_address
        return get_attribute(Yoti::Attribute::EMAIL_ADDRESS)
    end

    def date_of_birth
        return get_attribute(Yoti::Attribute::DATE_OF_BIRTH)
    end

    def gender
        return get_attribute(Yoti::Attribute::GENDER)
    end

    def nationality
        return get_attribute(Yoti::Attribute::NATIONALITY)
    end

    def postal_address
        postal_address = get_attribute(Yoti::Attribute::POSTAL_ADDRESS)

        return postal_address unless postal_address.nil?
        return get_formatted_address
    end

    def age_condition
        return get_attribute(Yoti::Attribute::AGE_CONDITION)
    end

    def structured_postal_address
        return get_attribute(Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS)
    end

    # return attribute value by name
    def get_attribute(attr_name)
        if @profile_data.has_key? attr_name then
            return @profile_data[attr_name]
        end
        return nil
    end

    protected

        def get_formatted_address
            full_address = structured_postal_address
            if !full_address.nil? && full_address.has_key?('formatted_address')
                return full_address['formatted_address']
            end
            return nil
        end
  end
end