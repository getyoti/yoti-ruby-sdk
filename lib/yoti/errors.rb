module Yoti
  # Raises exceptions related to Protobuf decoding
  class ProtobufError < StandardError; end

  # Raises exceptions related to API requests
  class RequestError < StandardError
    attr_reader :response

    def initialize(message, response = nil)
      super(append_response_message(message, response))
      @response = response
    end

    private

    def append_response_message(message, response)
      return message if response.nil? || response.body.empty?

      "#{message}: #{response.body}"
    end
  end

  # Raises exceptions related to OpenSSL actions
  class SslError < StandardError; end

  # Raises exceptions realted to an incorrect gem configuration value
  class ConfigurationError < StandardError; end

  # Raises exceptions related to AML actions
  class AmlError < StandardError; end

  # Raises exceptions related to Profile actions
  class ProfileError < StandardError; end
end
