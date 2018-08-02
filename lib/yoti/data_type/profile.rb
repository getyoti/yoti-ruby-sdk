module Yoti
  # Encapsulates the user profile data
  class Profile
    attr_reader :family_name

    attr_reader :given_names

    attr_reader :family_name

    def initialize(profile_data)
        @profile_data = profile_data
    end

    public
        def family_name
            return get_attribute('family_name')
        end

        def given_names
            return get_attribute('given_names')
        end

        def full_name
            return get_attribute('full_name')
        end

        def phone_number
            return get_attribute('phone_number')
        end

        def email_address
            return get_attribute('email_address')
        end

        def date_of_birth
            return get_attribute('date_of_birth')
        end

        def postal_address
            return get_attribute('postal_address')
        end

        def gender
            return get_attribute('gender')
        end

        def nationality
            return get_attribute('nationality')
        end

        def structured_postal_address
            return get_attribute('structured_postal_address')
        end

        def get_attribute(attr_name)
            if @profile_data.has_key? attr_name then
                return @profile_data[attr_name]
            end
            return nil
        end
  end
end