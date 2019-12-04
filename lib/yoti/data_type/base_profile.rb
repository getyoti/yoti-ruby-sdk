module Yoti
  #
  # Encapsulates Yoti user profile
  #
  class BaseProfile
    #
    # Return the first attribute for each attribute in the profile.
    #
    # @return [Hash{String => Yoti::Attribute}]
    #
    def attributes
      @attributes.map do |key, values|
        [key, values[0]]
      end.to_h
    end

    #
    # Returns the full list of all attributes
    #
    # @return [Array<Yoti::Attribute>>]
    #
    def attribute_list
      @attributes.map do |_, value|
        [value]
      end.flatten
    end

    #
    # @param [Hash{String => Yoti::Attribute},Array<Yoti::Attribute>] profile_data
    #
    def initialize(profile_data)
      @attributes = {}

      if profile_data.is_a? Hash
        @attributes = profile_data.map do |key, value|
          [key, [value]]
        end.to_h
      elsif profile_data.is_a? Array
        profile_data.reject(&:nil?).each do |attr|
          @attributes[attr.name] = [] unless @attributes[attr.name]
          @attributes[attr.name].push attr
        end
      end
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

      @attributes[attr_name][0]
    end

    #
    # Get all attributes with the given attribute name
    #
    # @param [String] name The name of the attribute
    #
    # @return [Array<Attribute>]
    #
    def get_all_attributes_by_name(name)
      return [] unless @attributes.key? name

      @attributes[name]
    end

    protected

    #
    # Find attributes starting with provided name.
    #
    # @param [String] name
    #
    # @returns [Hash]
    #
    def find_attributes_starting_with(name)
      @attributes.select { |key| key.to_s.start_with?(name) }.map do |key, values|
        [key, values[0]]
      end.to_h
    end
  end
end
