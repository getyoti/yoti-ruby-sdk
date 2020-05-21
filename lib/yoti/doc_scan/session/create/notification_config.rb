# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        #
        # Configures call-back Notifications to some backend endpoint provided
        # by the Relying Business.
        #
        # Notifications can be configured to notified a client backend of certain
        # events, avoiding the neeed to poll for the state of the Session.
        #
        class NotificationConfig
          #
          # @param [String] auth_token
          #   The authorization token to be included in call-back messages
          # @param [String] endpoint
          #   The endpoint that notifications should be sent to
          # @param [Array<String>] topics
          #   The list of topics that should trigger notifications
          #
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

          #
          # @return [NotificationConfigBuilder]
          #
          def self.builder
            NotificationConfigBuilder.new
          end
        end

        class NotificationConfigBuilder
          def initialize
            @topics = []
          end

          #
          # Sets the authorization token to be included in call-back messages
          #
          # @param [String] auth_token
          #
          # @return [self]
          #
          def with_auth_token(auth_token)
            @auth_token = auth_token
            self
          end

          #
          # Sets the endpoint that notifications should be sent to
          #
          # @param [String] endpoint
          #
          # @return [self]
          #
          def with_endpoint(endpoint)
            @endpoint = endpoint
            self
          end

          #
          # Adds a topic to the list of topics that trigger notification messages
          #
          # @param [String] topic
          #
          # @return [self]
          #
          def with_topic(topic)
            Validation.assert_is_a(String, topic, 'topic')
            @topics.push(topic)
            self
          end

          #
          # Adds RESOURCE_UPDATE to the list of topics that trigger notification messages
          #
          # @return [self]
          #
          def for_resource_update
            with_topic(Constants::RESOURCE_UPDATE)
          end

          #
          # Adds TASK_COMPLETION to the list of topics that trigger notification messages
          #
          # @return [self]
          #
          def for_task_completion
            with_topic(Constants::TASK_COMPLETION)
          end

          #
          # Adds CHECK_COMPLETION to the list of topics that trigger notification messages
          #
          # @return [self]
          #
          def for_check_completion
            with_topic(Constants::CHECK_COMPLETION)
          end

          #
          # Adds SESSION_COMPLETION to the list of topics that trigger notification messages
          #
          # @return [self]
          #
          def for_session_completion
            with_topic(Constants::SESSION_COMPLETION)
          end

          #
          # @return [NotificationConfig]
          #
          def build
            NotificationConfig.new(@auth_token, @endpoint, @topics)
          end
        end
      end
    end
  end
end
