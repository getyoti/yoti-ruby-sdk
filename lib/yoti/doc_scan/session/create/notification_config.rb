# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class NotificationConfig
          def initialize(auth_token, endpoint, topics)
            Validation.assert_is_a(String, auth_token, 'auth_token', true)
            @auth_token = auth_token

            Validation.assert_is_a(String, endpoint, 'endpoint', true)
            @endpoint = endpoint

            Validation.assert_is_a(Array, topics, 'auth_token', true)
            @topics = topics.uniq unless topics.nil?
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            {
              auth_token: @auth_token,
              endpoint: @endpoint,
              topics: @topics
            }.compact
          end

          def self.builder
            NotificationConfigBuilder.new
          end
        end

        class NotificationConfigBuilder
          def initialize
            @topics = []
          end

          def with_auth_token(auth_token)
            @auth_token = auth_token
            self
          end

          def with_endpoint(endpoint)
            @endpoint = endpoint
            self
          end

          def with_topic(topic)
            Validation.assert_is_a(String, topic, 'topic')
            @topics.push(topic)
            self
          end

          def for_resource_update
            with_topic(Constants::RESOURCE_UPDATE)
          end

          def for_task_completion
            with_topic(Constants::TASK_COMPLETION)
          end

          def for_check_completion
            with_topic(Constants::CHECK_COMPLETION)
          end

          def for_session_completion
            with_topic(Constants::SESSION_COMPLETION)
          end

          def build
            NotificationConfig.new(@auth_token, @endpoint, @topics)
          end
        end
      end
    end
  end
end
