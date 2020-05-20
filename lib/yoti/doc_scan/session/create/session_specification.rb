# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class SessionSpecification
          def initialize(
            client_session_token_ttl,
            resources_ttl,
            user_tracking_id,
            notifications,
            requested_checks,
            requested_tasks,
            sdk_config,
            required_documents
          )
            Validation.assert_is_a(Integer, client_session_token_ttl, 'client_session_token_ttl', true)
            @client_session_token_ttl = client_session_token_ttl

            Validation.assert_is_a(Integer, resources_ttl, 'resources_ttl', true)
            @resources_ttl = resources_ttl

            Validation.assert_is_a(String, user_tracking_id, 'user_tracking_id', true)
            @user_tracking_id = user_tracking_id

            Validation.assert_is_a(NotificationConfig, notifications, 'notifications', true)
            @notifications = notifications

            Validation.assert_is_a(Array, requested_checks, 'requested_checks', true)
            @requested_checks = requested_checks

            Validation.assert_is_a(Array, requested_tasks, 'requested_tasks', true)
            @requested_tasks = requested_tasks

            Validation.assert_is_a(SdkConfig, sdk_config, 'sdk_config', true)
            @sdk_config = sdk_config

            Validation.assert_is_a(Array, required_documents, 'required_documents', true)
            @required_documents = required_documents
          end

          def to_json(*args)
            as_json.to_json(*args)
          end

          def as_json(*_args)
            {
              client_session_token_ttl: @client_session_token_ttl,
              resources_ttl: @resources_ttl,
              user_tracking_id: @user_tracking_id,
              notifications: @notifications,
              requested_checks: @requested_checks.map(&:as_json),
              requested_tasks: @requested_tasks.map(&:as_json),
              sdk_config: @sdk_config,
              required_documents: @required_documents.map(&:as_json)
            }.compact
          end

          def self.builder
            SessionSpecificationBuilder.new
          end
        end

        class SessionSpecificationBuilder
          def initialize
            @requested_checks = []
            @requested_tasks = []
            @required_documents = []
          end

          def with_client_session_token_ttl(client_session_token_ttl)
            @client_session_token_ttl = client_session_token_ttl
            self
          end

          def with_resources_ttl(resources_ttl)
            @resources_ttl = resources_ttl
            self
          end

          def with_user_tracking_id(user_tracking_id)
            @user_tracking_id = user_tracking_id
            self
          end

          def with_notifications(notifications)
            @notifications = notifications
            self
          end

          def with_requested_check(requested_check)
            Validation.assert_is_a(RequestedCheck, requested_check, 'requested_check')
            @requested_checks.push(requested_check)
            self
          end

          def with_requested_task(requested_task)
            Validation.assert_is_a(RequestedTask, requested_task, 'requested_task')
            @requested_tasks.push(requested_task)
            self
          end

          def with_sdk_config(sdk_config)
            @sdk_config = sdk_config
            self
          end

          def with_required_document(required_document)
            Validation.assert_is_a(RequiredDocument, required_document, 'required_document')
            @required_documents.push(required_document)
            self
          end

          def build
            SessionSpecification.new(
              @client_session_token_ttl,
              @resources_ttl,
              @user_tracking_id,
              @notifications,
              @requested_checks,
              @requested_tasks,
              @sdk_config,
              @required_documents
            )
          end
        end
      end
    end
  end
end
