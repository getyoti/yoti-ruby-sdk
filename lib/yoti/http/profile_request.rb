module Yoti
  # Manage the API's profile requests
  module ProfileRequest
    def self.receipt(encrypted_connect_token)
      request = Yoti::Request.new
      request.encrypted_connect_token = encrypted_connect_token
      request.http_method = 'GET'
      request.endpoint = 'profile'
      request.receipt
    end
  end
end
