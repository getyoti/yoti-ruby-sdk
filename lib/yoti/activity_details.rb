require 'net/http'

module Yoti
  # Encapsulates the user profile data
  class ActivityDetails
    # @return [String] the outcome of the profile request, eg: SUCCESS
    attr_reader :outcome

    # @deprecated replaced by :remember_me_id
    # @return [String] the Yoti ID
    attr_reader :user_id

    # @return [String] the Remember Me ID
    attr_reader :remember_me_id

    # @return [String] the Parent Remember Me ID
    attr_reader :parent_remember_me_id

    # @return [Hash] the decoded profile attributes
    attr_reader :user_profile

    # @return [String] the selfie in base64 format
    attr_reader :base64_selfie_uri

    # @return [Boolean] the age under/over attribute
    attr_reader :age_verified

    # @param receipt [Hash] the receipt from the API request
    # @param decrypted_profile [Object] Protobuf AttributeList decrypted object containing the profile attributes
    def initialize(receipt, decrypted_profile = nil)
      process_decrypted_profile(decrypted_profile)
      @remember_me_id = receipt['remember_me_id']
      @user_id = @remember_me_id
      @parent_remember_me_id = receipt['parent_remember_me_id']
      @outcome = receipt['sharing_outcome']
    end

    # @return [Hash] a JSON of the address
    def structured_postal_address
      @user_profile['structured_postal_address']
    end

    # @return [Profile] of Yoti user
    def profile
      Yoti::Profile.new(@extended_profile)
    end

    protected

    def process_decrypted_profile(decrypted_profile)
      @user_profile = {}
      @extended_profile = {}
      @decrypted_profile = decrypted_profile

      return nil unless @decrypted_profile.is_a?(Object)
      return nil unless @decrypted_profile.respond_to?(:attributes)

      @decrypted_profile.attributes.each do |attribute|
        begin
          process_attribute(attribute)
        rescue StandardError => e
          Yoti::Log.logger.warn("#{e.message} (Attribute: #{attribute.name})")
        end

        @base64_selfie_uri = Yoti::Protobuf.image_uri_based_on_content_type(attribute.value, attribute.content_type) if attribute.name == 'selfie'
        @age_verified = attribute.value == 'true' if Yoti::AgeProcessor.is_age_verification(attribute.name)
      end
    end

    def process_attribute(attribute)
      attr_value = Yoti::Protobuf.value_based_on_content_type(attribute.value, attribute.content_type)
      @user_profile[attribute.name] = attr_value
      anchor_processor = Yoti::AnchorProcessor.new(attribute.anchors)
      anchors_list = anchor_processor.process
      @extended_profile[attribute.name] = Yoti::Attribute.new(attribute.name, attr_value, anchors_list['sources'], anchors_list['verifiers'])
    end
  end
end
