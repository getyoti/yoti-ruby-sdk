module Yoti
  #
  # Encapsulates Yoti user profile
  #
  class BaseProfile
    #
    # Return all attributes for the profile.
    #
    # @return [Hash{String => Yoti::Attribute}]
    #
    attr_reader :attributes

    #
    # @param [Hash{String => Yoti::Attribute}] profile_data
    #
    def initialize(profile_data)
      @attributes = profile_data.is_a?(Object) ? profile_data : {}
    end

    #
    # Get attribute value by name.
    #
    # @param [String] attr_name
    #
    # @return [Attribute, nil]
    #
    def get_attribute(attr_name)
      return nil unless @attributes.key? attr_name

      @attributes[attr_name]
    end

    protected

    #
    # Find attributes starting with provided name.
    #
    # @param [String] name
    #
    # @returns [Array]
    #
    def find_attributes_starting_with(name)
      @attributes.select { |key| key.to_s.start_with?(name) }
    end
  end
end
