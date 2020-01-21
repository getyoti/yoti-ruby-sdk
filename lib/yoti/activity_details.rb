require 'net/http'

module Yoti
  #
  # Details of an activity between a user and the application.
  #
  class ActivityDetails
    #
    # The outcome of the profile request, eg: SUCCESS
    #
    # @return [String]
    #
    attr_reader :outcome

    #
    # @deprecated replaced by :remember_me_id
    #
    # @return [String]
    #
    attr_reader :user_id

    #
    # Return the Remember Me ID, which is a unique, stable identifier for
    # a user in the context of an application.
    #
    # You can use it to identify returning users. This value will be different
    # for the same user in different applications.
    #
    # @return [String]
    #
    attr_reader :remember_me_id

    #
    # Return the Parent Remember Me ID, which is a unique, stable identifier for a
    # user in the context of an organisation.
    #
    # You can use it to identify returning users. This value is consistent for a
    # given user across different applications belonging to a single organisation.
    #
    # @return [String]
    #
    attr_reader :parent_remember_me_id

    #
    # The decoded profile attributes
    #
    # @deprecated replaced by :profile
    #
    # @return [Hash]
    #
    attr_reader :user_profile

    #
    # Base64 encoded selfie image
    #
    # @return [String]
    #
    attr_reader :base64_selfie_uri

    #
    # The age under/over attribute
    #
    # @deprecated 2.0.0 - replaced by:
    # - Yoti::Profile#age_verifications
    # - Yoti::Profile#find_age_over_verification
    # - Yoti::Profile#find_age_under_verification
    #
    # @return [Boolean]
    #
    attr_reader :age_verified

    #
    # Receipt ID identifying a completed activity
    #
    # @return [String]
    #
    attr_reader :receipt_id

    #
    # Time and date of the sharing activity
    #
    # @return [Time]
    #
    attr_reader :timestamp

    #
    # Extra data
    #
    # @return [ExtraData]
    #
    attr_reader :extra_data

    #
    # @param receipt [Hash] the receipt from the API request
    # @param decrypted_profile [Object] Protobuf AttributeList decrypted object containing the profile attributes
    #
    def initialize(receipt, decrypted_profile = nil, decrypted_application_profile = nil, extra_data = nil)
      @remember_me_id = receipt['remember_me_id']
      @user_id = @remember_me_id
      @receipt_id = receipt['receipt_id']
      @parent_remember_me_id = receipt['parent_remember_me_id']
      @outcome = receipt['sharing_outcome']
      @timestamp = receipt['timestamp'] ? Time.parse(receipt['timestamp']) : nil
      @extended_user_profile = process_decrypted_profile(decrypted_profile)
      @extended_application_profile = process_decrypted_profile(decrypted_application_profile)
      @extra_data = extra_data
      @user_profile = @extended_user_profile.map do |name, attribute|
        [name, attribute.value]
      end.to_h
    end

    #
    # The user's structured postal address as JSON
    #
    # @deprecated replaced by Yoti::Profile#structured_postal_address
    #
    # @return [Hash]
    #
    def structured_postal_address
      user_profile['structured_postal_address']
    end

    #
    # The user profile with shared attributes and anchor information, returned
    # by Yoti if the request was successful
    #
    # @return [Profile]
    #
    def profile
      Yoti::Profile.new(@extended_user_profile)
    end

    #
    # Profile of an application, with convenience methods to access well-known attributes
    #
    # @return [ApplicationProfile]
    #
    def application_profile
      Yoti::ApplicationProfile.new(@extended_application_profile)
    end

    protected

    #
    # Process the decrypted profile into key-value hash
    #
    # @param [Yoti::Protobuf::Attrpubapi::AttributeList] decrypted_profile
    #
    # @return [Hash]
    #
    def process_decrypted_profile(decrypted_profile)
      return {} unless decrypted_profile.is_a?(Object)
      return {} unless decrypted_profile.respond_to?(:attributes)

      profile_data = {}
      decrypted_profile.attributes.each do |attribute|
        begin
          profile_data[attribute.name] = process_attribute(attribute)
          process_age_verified(attribute)
        rescue StandardError => e
          Yoti::Log.logger.warn("#{e.message} (Attribute: #{attribute.name})")
        end
      end
      profile_data
    end

    #
    # Converts protobuf attribute into Attribute
    #
    # @param [Yoti::Protobuf::Attrpubapi::Attribute] attribute
    #
    # @return [Attribute, nil]
    #
    def process_attribute(attribute)
      # Application Logo can be empty, return nil when this occurs.
      return nil if attribute.name == Yoti::Attribute::APPLICATION_LOGO && attribute.value == ''

      attr_value = Yoti::Protobuf.value_based_on_content_type(attribute.value, attribute.content_type)
      attr_value = Yoti::Protobuf.value_based_on_attribute_name(attr_value, attribute.name)

      # Handle selfies for backwards compatibility.
      if attribute.name == Yoti::Attribute::SELFIE && attr_value.is_a?(Yoti::Image)
        @base64_selfie_uri = attr_value.base64_content
        attr_value = attr_value.content
      end

      anchors_list = Yoti::AnchorProcessor.new(attribute.anchors).process
      Yoti::Attribute.new(attribute.name, attr_value, anchors_list['sources'], anchors_list['verifiers'], anchors_list)
    end

    #
    # Processes age verification
    #
    # @deprecated 2.0.0
    #
    # @param [Yoti::Protobuf::Attrpubapi::Attribute] attribute
    #
    def process_age_verified(attribute)
      @age_verified = attribute.value == 'true' if Yoti::AgeProcessor.is_age_verification(attribute.name)
    end
  end
end
