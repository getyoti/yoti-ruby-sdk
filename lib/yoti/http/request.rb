require 'securerandom'
require 'cgi'

module Yoti
  # Manage the API's HTTPS requests
  class Request
    # @deprecated will be removed in 2.0.0 - token is now provided with the endpoint
    # @return [String] the URL token received from Yoti Connect
    attr_accessor :encrypted_connect_token

    # @return [String] the base URL
    attr_writer :base_url

    # @return [Hash] query params to add to the request
    attr_accessor :query_params

    # @return [String] the HTTP method used for the request
    # The allowed methods are: GET, DELETE, POST, PUT, PATCH
    attr_accessor :http_method

    # @return [String] the API endpoint for the request
    attr_accessor :endpoint

    # @return [#to_json,String] the body sent with the request
    attr_accessor :payload

    def initialize
      @headers = {}
    end

    #
    # @return [RequestBuilder]
    #
    def self.builder
      RequestBuilder.new
    end

    #
    # Adds a HTTP header to the request
    #
    # @param [String] header
    # @param [String] value
    #
    def add_header(header, value)
      @headers[header] = value
    end

    #
    # Makes a HTTP request after signing the headers
    #
    # @return [HTTPResponse]
    #
    def execute
      raise RequestError, 'The request requires a HTTP method.' unless @http_method

      http_res = Net::HTTP.start(uri.hostname, Yoti.configuration.api_port, use_ssl: https_uri?) do |http|
        signed_request = SignedRequest.new(unsigned_request, path, @payload).sign
        http.request(signed_request)
      end

      raise RequestError.new("Unsuccessful Yoti API call: #{http_res.message}", http_res) unless response_is_success(http_res)

      http_res
    end

    #
    # Makes a HTTP request and returns the body after signing the headers
    #
    # @return [String]
    #
    def body
      execute.body
    end

    #
    # @return [String] the base URL
    #
    def base_url
      @base_url ||= Yoti.configuration.api_endpoint
    end

    private

    #
    # @param [Net::HTTPResponse] http_res
    #
    # @return [Boolean]
    #
    def response_is_success(http_res)
      http_res.code.to_i >= 200 && http_res.code.to_i < 300
    end

    #
    # Adds payload to provided HTTP request
    #
    # @param [Net::HTTPRequest] http_req
    #
    def add_payload(http_req)
      return if @payload.to_s.empty?

      if @payload.is_a?(String)
        http_req.body = @payload
      elsif @payload.respond_to?(:to_json)
        http_req.body = @payload.to_json
      end
    end

    #
    # @return [Net::HTTPRequest] the unsigned HTTP request
    #
    def unsigned_request
      case @http_method
      when 'GET'
        http_req = Net::HTTP::Get.new(uri)
      when 'DELETE'
        http_req = Net::HTTP::Delete.new(uri)
      when 'POST'
        http_req = Net::HTTP::Post.new(uri)
        add_payload(http_req)
      when 'PUT'
        http_req = Net::HTTP::Put.new(uri)
        add_payload(http_req)
      when 'PATCH'
        http_req = Net::HTTP::Patch.new(uri)
        add_payload(http_req)
      else
        raise RequestError, "Request method not allowed: #{@http_method}"
      end

      @headers.each do |header, value|
        http_req[header] = value
      end

      http_req
    end

    #
    # @return [URI] the full request URI
    #
    def uri
      @uri ||= URI(base_url + path)
    end

    #
    # @return [String] the path with query string
    #
    def path
      @path ||= "/#{@endpoint}/#{token}".chomp('/') + "?#{query_string}"
    end

    #
    # @deprecated will be removed in 2.0.0 - token is now provided with the endpoint
    #
    # @return [String] the decrypted connect token
    #
    def token
      return '' unless @encrypted_connect_token

      Yoti::SSL.decrypt_token(@encrypted_connect_token)
    end

    def https_uri?
      uri.scheme == 'https'
    end

    #
    # Builds query string including nonce and timestamp
    #
    # @return [String]
    #
    def query_string
      params = {
        nonce: SecureRandom.uuid,
        timestamp: Time.now.to_i
      }

      if @query_params.nil?
        # @deprecated this default will be removed in 2.0.0
        # Append appId when no custom query params are provided.
        params.merge!(appId: Yoti.configuration.client_sdk_id)
      else
        Validation.assert_is_a(Hash, @query_params, 'query_params')
        params.merge!(@query_params)
      end

      params.map do |k, v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      end.join('&')
    end
  end

  #
  # Builder for {Request}
  #
  class RequestBuilder
    def initialize
      @headers = {}
      @query_params = {}
    end

    #
    # Sets the base URL
    #
    # @param [String] base_url
    #
    # @return [self]
    #
    def with_base_url(base_url)
      Validation.assert_is_a(String, base_url, 'base_url')
      @base_url = base_url
      self
    end

    #
    # Adds a HTTP header to the request
    #
    # @param [String] header
    # @param [String] value
    #
    # @return [self]
    #
    def with_header(header, value)
      Validation.assert_is_a(String, header, 'header')
      Validation.assert_is_a(String, value, 'value')
      @headers[header] = value
      self
    end

    #
    # Adds a query parameter to the request
    #
    # @param [String] key
    # @param [String] value
    #
    # @return [self]
    #
    def with_query_param(key, value)
      Validation.assert_is_a(String, key, 'key')
      Validation.assert_is_a(String, value, 'value')
      @query_params[key] = value
      self
    end

    #
    # Sets the HTTP method
    #
    # @param [String] http_method
    #
    # @return [self]
    #
    def with_http_method(http_method)
      Validation.assert_is_a(String, http_method, 'http_method')
      @http_method = http_method
      self
    end

    #
    # Sets the API endpoint for the request
    #
    # @param [String] endpoint
    #
    # @return [self]
    #
    def with_endpoint(endpoint)
      Validation.assert_is_a(String, endpoint, 'endpoint')
      @endpoint = endpoint
      self
    end

    #
    # Sets the body sent with the request
    #
    # @param [#to_json,String] payload
    #
    # @return [self]
    #
    def with_payload(payload)
      Validation.assert_respond_to(:to_json, payload, 'payload') unless payload.is_a?(String)
      @payload = payload
      self
    end

    #
    # @return [Request]
    #
    def build
      request = Request.new
      request.base_url = @base_url
      request.endpoint = @endpoint
      request.query_params = @query_params
      request.http_method = @http_method
      request.payload = @payload
      @headers.map { |k, v| request.add_header(k, v) }
      request
    end
  end
end
