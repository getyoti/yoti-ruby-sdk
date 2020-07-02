module Yoti
  # Manage the API's profile requests
  class ProfileRequest
    #
    # @param [String] encrypted_connect_token
    #
    def initialize(encrypted_connect_token)
      @encrypted_connect_token = encrypted_connect_token
      @request = request
    end

    # @return [String] a JSON representation of the profile response receipt
    def receipt
      JSON.parse(@request.body)['receipt']
    end

    private

    def request
      Yoti::Request
        .builder
        .with_http_method('GET')
        .with_base_url(Yoti.configuration.api_endpoint)
        .with_endpoint("profile/#{Yoti::SSL.decrypt_token(@encrypted_connect_token)}")
        .with_query_param('appId', Yoti.configuration.client_sdk_id)
        .with_header('X-Yoti-Auth-Key', Yoti::SSL.auth_key_from_pem)
        .with_max_retries(0)
        .build
    end
  end
end
