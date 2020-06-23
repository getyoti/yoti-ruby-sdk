require 'json'

module Yoti
  module DocScan
    #
    # Raises exceptions related to Doc Scan API requests
    #
    class Error < RequestError
      def initialize(msg = nil, response = nil)
        super(msg, response)

        @default_message = msg
      end

      def message
        @message ||= format_message
      end

      #
      # Wraps an existing error
      #
      # @param [Error] error
      #
      # @return [self]
      #
      def self.wrap(error)
        new(error.message, error.response)
      end

      private

      #
      # Formats error message from response.
      #
      # @return [String]
      #
      def format_message
        return @default_message if @response.nil? || @response['Content-Type'] != 'application/json'

        json = JSON.parse(@response.body)
        format_response(json) || @default_message
      end

      #
      # Format JSON error response.
      #
      # @param [Hash] json
      #
      # @return [String, nil]
      #
      def format_response(json)
        return nil if json['code'].nil? || json['message'].nil?

        code_message = "#{json['code']} - #{json['message']}"

        unless json['errors'].nil?
          property_errors = format_property_errors(json['errors'])

          return "#{code_message}: #{property_errors.compact.join(', ')}" if property_errors.count.positive?
        end

        code_message
      end

      #
      # Format property errors.
      #
      # @param [Array<Hash>] errors
      #
      # @return [Array<String>]
      #
      def format_property_errors(errors)
        errors
          .map do |e|
            "#{e['property']} \"#{e['message']}\"" if e['property'] && e['message']
          end
          .compact
      end
    end
  end
end
