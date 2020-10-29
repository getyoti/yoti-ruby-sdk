require 'base64'

module Yoti
  # Converts a basic Net::HTTP request into a Yoti Signed Request
  class SignedRequest
    #
    # @param [Net::HTTPRequest] unsigned_request
    # @param [String] path
    # @param [#to_json,String] payload
    #
    def initialize(unsigned_request, path, payload = {})
      @http_req = unsigned_request
      @path = path
      @payload = payload
      @auth_key = Yoti::SSL.auth_key_from_pem
    end

    #
    # @return [Net::HTTPRequest]
    #
    def sign
      @http_req['X-Yoti-Auth-Digest'] = message_signature
      @http_req['X-Yoti-SDK'] = Yoti.configuration.sdk_identifier
      @http_req['X-Yoti-SDK-Version'] = "#{Yoti.configuration.sdk_identifier}-#{Yoti::VERSION}"
      @http_req
    end

    private

    def message_signature
      @message_signature ||= Yoti::SSL.get_secure_signature("#{http_method}&#{@path}#{base64_payload}")
    end

    def http_method
      @http_req.method
    end

    def base64_payload
      return '' unless @payload

      payload_string = @payload.is_a?(String) ? @payload : @payload.to_json

      "&#{Base64.strict_encode64(payload_string)}"
    end
  end
end
