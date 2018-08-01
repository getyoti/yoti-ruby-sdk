require 'net/http'

module Yoti
  # Encapsulates the user profile data
  class ActivityDetails
    # @return [String] the outcome of the profile request, eg: SUCCESS
    attr_reader :outcome

    # @return [String] the Yoti ID
    attr_reader :user_id

    # @return [Hash] the decoded profile attributes
    attr_reader :user_profile

    # @return [String] the selfie in base64 format
    attr_reader :base64_selfie_uri

    # @return [Boolean] the age under/over attribute
    attr_reader :age_verified

    # @param receipt [Hash] the receipt from the API request
    # @param decrypted_profile [Object] Protobuf AttributeList decrypted object containing the profile attributes
    def initialize(receipt, decrypted_profile = nil)
      @decrypted_profile = decrypted_profile
      @user_profile = {}
      @extended_profile = {}

      if !@decrypted_profile.nil? && @decrypted_profile.respond_to_has_and_present?(:attributes)
        @decrypted_profile.attributes.each do |field|
          @user_profile[field.name] = Yoti::Protobuf.value_based_on_content_type(field.value, field.content_type)
          anchor_processor = Yoti::AnchorProcessor.new(field.anchors)
          parsed_anchors = anchor_processor.process
          @extended_profile[field.name] = Yoti::Attribute.new(field.name, field.value, parsed_anchors['sources'], parsed_anchors['verifiers'])

          if field.name == 'selfie'
            @base64_selfie_uri = Yoti::Protobuf.image_uri_based_on_content_type(field.value, field.content_type)
          end

          # check if the key matches the format age_[over|under]:[1-999]
          if /age_(over|under):[1-9][0-9]?[0-9]?/.match?(field.name)
            @age_verified = field.value == 'true'
          end
        end
      end

      @user_id = receipt['remember_me_id']
      @outcome = receipt['sharing_outcome']
    end

    public

        # @return [Hash] a JSON of the address
        def structured_postal_address
            @user_profile['structured_postal_address']
        end

        def profile
            return Yoti::Profile.new(@extended_profile)
        end
  end
end
