# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # The response to a successful CreateSession call
        #
        class CreateSessionResult
          #
          # Returns the time-to-live (TTL) for the client session
          # token for the created session
          #
          # @return [Integer]
          #
          attr_reader :client_session_token_ttl

          #
          # Returns the client session token for the created session
          #
          # @return [String]
          #
          attr_reader :client_session_token

          #
          # Session ID of the created session
          #
          # @return [String]
          #
          attr_reader :session_id

          #
          # @param [Hash] response
          #
          def initialize(response)
            Validation.assert_is_a(Integer, response['client_session_token_ttl'], 'client_session_token_ttl', true)
            @client_session_token_ttl = response['client_session_token_ttl']

            Validation.assert_is_a(String, response['client_session_token'], 'client_session_token', true)
            @client_session_token = response['client_session_token']

            Validation.assert_is_a(String, response['session_id'], 'session_id', true)
            @session_id = response['session_id']
          end
        end
      end
    end
  end
end
