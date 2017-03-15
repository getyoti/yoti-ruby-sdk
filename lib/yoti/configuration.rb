module Yoti
  class Configuration
    attr_accessor :client_sdk_id, :key_file_path, :key, :api_url,
                  :api_port, :api_version, :api_endpoint

    # Set config variables by using a configuration block
    def initialize
      @client_sdk_id = ''
      @key_file_path = ''
      @key = ''
      @api_url = 'https://api.yoti.com'
      @api_port = 443
      @api_version = 'v1'
    end

    # @return [String] the API endpoint for the selected API version
    def api_endpoint
      @api_endpoint ||= "#{@api_url}/api/#{@api_version}"
    end

    # Validates the configuration values set in instance variables
    # @return [nil]
    def validate
      validate_required_all(%w(client_sdk_id))
      validate_required_any(%w(key_file_path key))
      validate_value('api_version', ['v1'])
    end

    private

    # Loops through the list of required configurations and raises an error
    # if a it can't find all the configuration values set
    # @return [nil]
    def validate_required_all(required_configs)
      required_configs.each do |config|
        unless config_set?(config)
          message = "Configuration value `#{config}` is required."
          raise ConfigurationError, message
        end
      end
    end

    # Loops through the list of required configurations and raises an error
    # if a it can't find at least one configuration value set
    # @return [nil]
    def validate_required_any(required_configs)
      valid = required_configs.select { |config| config_set?(config) }

      return if valid.any?

      config_list = required_configs.map { |conf| '`' + conf + '`' }.join(', ')
      message = "At least one of the configuration values has to be set: #{config_list}."
      raise ConfigurationError, message
    end

    # Raises an error if the setting receives an invalid value
    # @param config [String] the value to be assigned
    # @param allowed_values [Array] an array of allowed values for the variable
    # @return [nil]
    def validate_value(config, allowed_values)
      value = instance_variable_get("@#{config}")

      return unless invalid_value?(value, allowed_values)

      message = "Configuration value `#{value}` is not allowed for `#{config}`."
      raise ConfigurationError, message
    end

    # Checks if an allowed array of values includes the setting value
    # @param value [String] the value to be checked
    # @param allowed_values [Array] an array of allowed values for the variable
    # @return [Boolean]
    def invalid_value?(value, allowed_values)
      allowed_values.any? && !allowed_values.include?(value)
    end

    # Checks if a configuration has been set as a instance variable
    # @param config [String] the name of the configuration
    # @return [Boolean]
    def config_set?(config)
      instance_variable_get("@#{config}").to_s != ''
    end
  end
end
