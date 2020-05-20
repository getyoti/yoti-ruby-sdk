# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class GetSessionResult
          attr_reader :client_session_token_ttl, :client_session_token, :session_id, :user_tracking_id,
                      :state, :checks, :resources

          def initialize(response)
            Validation.assert_is_a(Integer, response['client_session_token_ttl'], 'client_session_token_ttl', true)
            @client_session_token_ttl = response['client_session_token_ttl']

            Validation.assert_is_a(String, response['session_id'], 'session_id', true)
            @session_id = response['session_id']

            Validation.assert_is_a(String, response['user_tracking_id'], 'user_tracking_id', true)
            @user_tracking_id = response['user_tracking_id']

            Validation.assert_is_a(String, response['state'], 'state', true)
            @state = response['state']

            Validation.assert_is_a(String, response['client_session_token'], 'client_session_token', true)
            @client_session_token = response['client_session_token']

            if response['checks'].nil?
              @checks = []
            else
              Validation.assert_is_a(Array, response['checks'], 'checks')
              @checks = map_checks(response['checks'])
            end

            @resources = ResourceContainer.new(response['resources']) unless response['resources'].nil?
          end

          def authenticity_checks
            @checks.filter { |check| check.is_a?(AuthenticityCheckResponse) }
          end

          def face_match_checks
            @checks.filter { |check| check.is_a?(FaceMatchCheckResponse) }
          end

          def text_data_checks
            @checks.filter { |check| check.is_a?(TextDataCheckResponse) }
          end

          def liveness_checks
            @checks.filter { |check| check.is_a?(LivenessCheckResponse) }
          end

          private

          def map_checks(checks)
            checks.map do |check|
              case check['type']
              when Constants::ID_DOCUMENT_AUTHENTICITY
                AuthenticityCheckResponse.new(check)
              when Constants::ID_DOCUMENT_FACE_MATCH
                FaceMatchCheckResponse.new(check)
              when Constants::ID_DOCUMENT_TEXT_DATA_CHECK
                TextDataCheckResponse.new(check)
              when Constants::LIVENESS
                LivenessCheckResponse.new(check)
              else
                CheckResponse.new(check)
              end
            end
          end
        end
      end
    end
  end
end
