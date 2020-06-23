module Yoti
  # Raises exceptions related to Protobuf decoding
  class ProtobufError < StandardError; end

  # Raises exceptions related to API requests
  class RequestError < StandardError
    attr_reader :response

    def initialize(message, response = nil)
      super(message)
      @response = response
    end

    def message
      return super if @response.nil? || @response.body.empty?

      "#{super}: #{@response.body}"
    end
  end

  # Raises exceptions related to OpenSSL actions
  class SslError < StandardError; end

  # Raises exceptions related to an incorrect gem configuration value
  class ConfigurationError < StandardError; end

  # Raises exceptions related to AML actions
  class AmlError < StandardError; end

  # Raises exceptions related to Profile actions
  class ProfileError < StandardError; end
end
