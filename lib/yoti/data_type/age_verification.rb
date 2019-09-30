module Yoti
  #
  # Wraps an 'Age Verify/Condition' attribute to provide behaviour specific
  # to verifying someone's age.
  #
  class AgeVerification
    #
    # The wrapped profile attribute.
    #
    # Use this if you need access to the underlying list of Anchors.
    #
    # @return [Yoti::Attribute]
    #
    attr_reader :attribute

    #
    # Whether or not the profile passed the age check.
    #
    # @return [Boolean]
    #
    attr_reader :result

    #
    # The type of age check performed, as specified on Yoti Hub.
    #
    # Among the possible values are 'age_over' and 'age_under'.
    #
    # @return [String]
    #
    attr_reader :check_type

    #
    # The age that was that checked, as specified on Yoti Hub.
    #
    # @return [Integer]
    #
    attr_reader :age

    #
    # @param [Yoti::Attribute]
    #
    def initialize(attribute)
      raise(ArgumentError, "'#{attribute.name}' is not a valid age verification") unless /^[^:]+:(?!.*:)[0-9]+$/.match?(attribute.name)

      @attribute = attribute

      split = attribute.name.split(':')
      @check_type = split[0]

      @age = split[1].to_i
      @result = attribute.value == 'true'
    end
  end
end
