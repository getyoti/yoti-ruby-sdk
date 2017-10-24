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

    # @param receipt [Hash] the receipt from the API request
    # @param decrypted_profile [Object] Protobuf AttributeList decrypted object containing the profile attributes
    def initialize(receipt, decrypted_profile = nil)
      @decrypted_profile = decrypted_profile
      @user_profile = {}

      if !@decrypted_profile.nil? && @decrypted_profile.respond_to_has_and_present?(:attributes)
        @decrypted_profile.attributes.each do |field|
          @user_profile[field.name] = Yoti::Protobuf.value_based_on_content_type(field.value, field.content_type)

          if field.name == 'selfie'
            @base64_selfie_uri = Yoti::Protobuf.image_uri_based_on_content_type(field.value, field.content_type)
          end
        end
      end

      @user_id = receipt['remember_me_id']
      @outcome = receipt['sharing_outcome']
    end
  end
end
