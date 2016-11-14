module Yoti
  # Manage the API's HTTPS requests
  class Request
    def initialize(encrypted_connect_token)
      @encrypted_connect_token = encrypted_connect_token
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
      http_req = Net::HTTP::Get.new(uri)
      http_req['X-Yoti-Auth-Key'] = @auth_key
      http_req['X-Yoti-Auth-Digest'] = message_signature
      http_req['Content-Type'] = 'application/json'
      http_req['Accept'] = 'application/json'
      http_req
    end

    def message_signature
      @message_signature ||= Yoti::SSL.get_secure_signature("GET&#{path}")
    end

    def uri
      @uri ||= URI(Yoti.configuration.api_endpoint + path)
    end

    def path
      @path ||= begin
        nonce = SecureRandom.uuid
        timestamp = Time.now.to_i
        "/profile/#{token}?nonce=#{nonce}&timestamp=#{timestamp}&appId=#{Yoti.configuration.client_sdk_id}"
      end
    end

    def token
      @token ||= Yoti::SSL.decrypt_token(@encrypted_connect_token)
    end

    def https_uri?
      uri.scheme == 'https'
    end
  end
end
