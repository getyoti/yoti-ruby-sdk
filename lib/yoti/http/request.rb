module Yoti
  # Manage the API's HTTPS requests
  class Request
    attr_accessor :encrypted_connect_token, :http_method, :endpoint, :payload

    # @return [Hash] the receipt key from the request hash response
    def receipt
      raise RequestError, 'The request requires a HTTP method.' unless @http_method
      raise RequestError, 'The payload needs to be a hash.' unless @payload.to_s.empty? || @payload.is_a?(Hash)

      res = Net::HTTP.start(uri.hostname, Yoti.configuration.api_port, use_ssl: https_uri?) do |http|
        signed_request = SignedRequest.new(unsigned_request, path, @payload).sign
        http.request(signed_request)
      end

      raise RequestError, "Unsuccessful Yoti API call: #{res.message}" unless res.code == '200'
      JSON.parse(res.body)['receipt']
    end

    private

    def unsigned_request
      case @http_method
      when 'GET'
        http_req = Net::HTTP::Get.new(uri)
      when 'DELETE'
        http_req = Net::HTTP::Delete.new(uri)
      when 'POST'
        http_req = Net::HTTP::Post.new(uri)
        http_req.set_form_data(@payload) unless @payload.to_s.empty?
      when 'PUT'
        http_req = Net::HTTP::Put.new(uri)
        http_req.set_form_data(@payload) unless @payload.to_s.empty?
      when 'PATCH'
        http_req = Net::HTTP::Patch.new(uri)
        http_req.set_form_data(@payload) unless @payload.to_s.empty?
      else
        raise RequestError, "Request method not allowed: #{@http_method}"
      end

      http_req
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
        "&appId=#{Yoti.configuration.client_sdk_id}"
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
