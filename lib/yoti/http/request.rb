require 'securerandom'

module Yoti
  # Manage the API's HTTPS requests
  class Request
    # @return [String] the URL token received from Yoti Connect
    attr_accessor :encrypted_connect_token

    # @return [String] the HTTP method used for the request
    # The allowed methods are: GET, DELETE, POST, PUT, PATCH
    attr_accessor :http_method

    # @return [String] the API endpoint for the request
    attr_accessor :endpoint

    # @return [Hash] the body sent with the request
    attr_accessor :payload

    def initialize
      @headers = {}
    end

    # Adds a HTTP header to the request
    def add_header(header, value)
      @headers[header] = value
    end

    # Makes a HTTP request after signing the headers
    # @return [Hash] the body from the HTTP request
    def body
      raise RequestError, 'The request requires a HTTP method.' unless @http_method
      raise RequestError, 'The payload needs to be a hash.' unless @payload.to_s.empty? || @payload.is_a?(Hash)

      res = Net::HTTP.start(uri.hostname, Yoti.configuration.api_port, use_ssl: https_uri?) do |http|
        signed_request = SignedRequest.new(unsigned_request, path, @payload).sign
        http.request(signed_request)
      end

      raise RequestError, "Unsuccessful Yoti API call: #{res.message}" unless res.code == '200'

      res.body
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
        http_req.body = @payload.to_json unless @payload.to_s.empty?
      when 'PUT'
        http_req = Net::HTTP::Put.new(uri)
        http_req.body = @payload.to_json unless @payload.to_s.empty?
      when 'PATCH'
        http_req = Net::HTTP::Patch.new(uri)
        http_req.body = @payload.to_json unless @payload.to_s.empty?
      else
        raise RequestError, "Request method not allowed: #{@http_method}"
      end

      @headers.each do |header, value|
        http_req[header] = value
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
      return '' unless @encrypted_connect_token

      Yoti::SSL.decrypt_token(@encrypted_connect_token)
    end

    def https_uri?
      uri.scheme == 'https'
    end
  end
end
