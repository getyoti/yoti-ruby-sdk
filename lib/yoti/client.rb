module Yoti
  #
  # Handles all the publicly accesible Yoti methods for
  # geting data using an encrypted connect token
  #
  module Client
    #
    # Performs all the steps required to get the decrypted profile from an API request
    #
    # @param encrypted_connect_token [String] token provided as a base 64 string
    #
    # @return [Object] an ActivityDetails instance encapsulating the user profile
    #
    def self.get_activity_details(encrypted_connect_token)
      receipt = Yoti::ProfileRequest.new(encrypted_connect_token).receipt
      user_profile = Protobuf.user_profile(receipt)
      application_profile = Protobuf.application_profile(receipt)

      return ActivityDetails.new(receipt) if user_profile.nil?

      ActivityDetails.new(receipt, user_profile, application_profile)
    end

    def self.aml_check(aml_profile)
      Yoti::AmlCheckRequest.new(aml_profile).response
    end
  end
end
