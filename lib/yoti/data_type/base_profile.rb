module Yoti
  #
  # Encapsulates Yoti user profile
  #
  class BaseProfile
    #
    # @param [Object] profile_data
    #
    def initialize(profile_data)
      profile_data = {} unless profile_data.is_a? Object
      @profile_data = profile_data
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
  end
end
