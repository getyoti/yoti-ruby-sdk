require 'base64'

module Yoti
  # Converts a basic Net::HTTP request into a Yoti Signed Request
  class SignedRequest
    def initialize(unsigned_request, path, payload = {})
      @http_req = unsigned_request
      @path = path
      @payload = payload
      @auth_key = Yoti::SSL.auth_key_from_pem
    end

    def sign
      @http_req['X-Yoti-Auth-Key'] = @auth_key
      @http_req['X-Yoti-Auth-Digest'] = message_signature
      @http_req['X-Yoti-SDK'] = Yoti.configuration.sdk_identifier
      @http_req['Content-Type'] = 'application/json'
      @http_req['Accept'] = 'application/json'
      @http_req
    end

    private

    def message_signature
      @message_signature ||= Yoti::SSL.get_secure_signature("#{http_method}&#{@path}#{payload_string}")
    end

    def http_method
      @http_req.method
    end

    # Create the base64 encoded request body
    def payload_string
      return '' unless @payload

      payload_serialized = Marshal.dump(@payload)
      payload_byte_array = payload_serialized.bytes
      payload_byte_string = Marshal.dump(payload_byte_array)
      '&' + Base64.strict_encode64(payload_byte_string)
    end
  end
end
