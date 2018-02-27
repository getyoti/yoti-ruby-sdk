module Yoti
  # Handles all the publicly accesible Yoti methods for
  # geting data using an encrypted connect token
  module Client
    # Performs all the steps required to get the decrypted profile from an API request
    # @param encrypted_connect_token [String] token provided as a base 64 string
    # @return [Object] an ActivityDetails instance encapsulating the user profile
    def self.get_activity_details(encrypted_connect_token)
      receipt = Yoti::ProfileRequest.new(encrypted_connect_token).receipt
      encrypted_data = Protobuf.current_user(receipt)

      return ActivityDetails.new(receipt) if encrypted_data.nil?

      unwrapped_key = Yoti::SSL.decrypt_token(receipt['wrapped_receipt_key'])
      decrypted_data = Yoti::SSL.decipher(unwrapped_key, encrypted_data.iv, encrypted_data.cipher_text)
      decrypted_profile = Protobuf.attribute_list(decrypted_data)
      ActivityDetails.new(receipt, decrypted_profile)
    end

    def self.aml_check(aml_profile)
      Yoti::AmlCheckRequest.new(aml_profile).response
    end
  end
end
