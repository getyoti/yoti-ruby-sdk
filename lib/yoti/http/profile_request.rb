module Yoti
  # Manage the API's profile requests
  module ProfileRequest
    def self.receipt(encrypted_connect_token)
      Yoti::Request.new(encrypted_connect_token, 'GET', 'profile').receipt
    end
  end
end
