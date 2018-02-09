module Yoti
  # Raises exceptions related to Protobuf decoding
  class ProtobufError < StandardError; end

  # Raises exceptions related to API requests
  class RequestError < StandardError; end

  # Raises exceptions related to OpenSSL actions
  class SslError < StandardError; end

  # Raises exceptions realted to an incorrect gem configuration value
  class ConfigurationError < StandardError; end

  # Raises exceptions related to AML actions
  class AmlError < StandardError; end
end
