# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class CreateSessionResult
          attr_reader :client_session_token_ttl, :client_session_token, :session_id

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
