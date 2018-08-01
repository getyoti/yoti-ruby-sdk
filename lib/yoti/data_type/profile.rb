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
            return self.get_attribute('family_name')
        end

        def given_names
            return self.get_attribute('given_names')
        end

        def get_attribute(attr_name)
            if @profile_data.has_key? attr_name then
                return @profile_data[attr_name]
            end
            return nil
        end
  end
end