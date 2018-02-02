require 'base64'

module Yoti
  # Manage the API's HTTPS requests
  class Request
    attr_accessor :encrypted_connect_token, :http_method, :endpoint, :payload

    def initialize
      @auth_key = Yoti::SSL.auth_key_from_pem
    end

    # @return [Hash] the receipt key from the request hash response
    def receipt
      request['receipt']
    end

    private

    def request
      res = Net::HTTP.start(uri.hostname, Yoti.configuration.api_port, use_ssl: https_uri?) do |http|
        http.request(req)
      end

      raise RequestError, "Unsuccessful Yoti API call: #{res.message}" unless res.code == '200'
      JSON.parse(res.body)
    end

    def req
      raise RequestError, 'The request requires a HTTP method.' unless @http_method
      raise RequestError, 'The payload needs to be a hash.' unless payload.to_s.empty? || @payload.is_a?(Hash)

      case @http_method
      when 'GET', 'DELETE'
        http_req = Net::HTTP::Get.new(uri)
      when 'POST', 'PUT', 'PATCH'
        http_req = Net::HTTP::Get.new(uri)
        http_req.set_form_data(@payload)
      else
        raise RequestError, "Request method not allowed: #{@http_method}"
      end

      http_req['X-Yoti-Auth-Key'] = @auth_key
      http_req['X-Yoti-Auth-Digest'] = message_signature
      http_req['X-Yoti-SDK'] = @sdk_identifier
      http_req['Content-Type'] = 'application/json'
      http_req['Accept'] = 'application/json'
      http_req
    end

    def message_signature
      @message_signature ||= Yoti::SSL.get_secure_signature("#{@http_method}&#{path}")
    end

    def uri
      @uri ||= URI(Yoti.configuration.api_endpoint + path)
    end

    def path
      @path ||= begin
        nonce = SecureRandom.uuid
        timestamp = Time.now.to_i

        "/#{@endpoint}/#{token}"\
        "?nonce=#{nonce}"\
        "&timestamp=#{timestamp}"\
        "&appId=#{Yoti.configuration.client_sdk_id}"\
        "#{payload.nil? ? '' : '&' + payload_string}"
      end
    end

    def token
      @token ||= Yoti::SSL.decrypt_token(@encrypted_connect_token)
    end

    def https_uri?
      uri.scheme == 'https'
    end

    # Create the base64 encoded request body
    def payload_string
      payload_serialized = Marshal.dump(@payload)
      payload_byte_array = payload_serialized.bytes
      payload_byte_string = Marshal.dump(payload_byte_array)
      Base64.strict_encode64(payload_byte_string)
    end
  end
end
