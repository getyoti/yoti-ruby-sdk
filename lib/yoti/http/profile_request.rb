module Yoti
  # Manage the API's profile requests
  class ProfileRequest
    def initialize(encrypted_connect_token)
      @encrypted_connect_token = encrypted_connect_token
      @request = request
    end

    def receipt
      @request.receipt
    end

    private

    def request
      yoti_request = Yoti::Request.new
      yoti_request.encrypted_connect_token = @encrypted_connect_token
      yoti_request.http_method = 'GET'
      yoti_request.endpoint = 'profile'
      yoti_request
    end
  end
end
