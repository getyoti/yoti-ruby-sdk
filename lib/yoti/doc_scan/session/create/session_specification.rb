# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class SessionSpecification
          #
          # @param [Integer] client_session_token_ttl
          # @param [Integer] resources_ttl
          # @param [String] user_tracking_id
          # @param [NotificationConfig] notifications
          # @param [Array<RequestedCheck>] requested_checks
          # @param [Array<RequestedTask>] requested_tasks
          # @param [SdkConfig] sdk_config
          # @param [Array<RequiredDocument>] required_documents
          # @param [Boolean] block_biometric_consent
          # @param [Hash] identity_profile_requirements
          #
          def initialize(
            client_session_token_ttl,
            resources_ttl,
            user_tracking_id,
            notifications,
            requested_checks,
            requested_tasks,
            sdk_config,
            required_documents,
            block_biometric_consent = nil,
            identity_profile_requirements = nil
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

            @block_biometric_consent = block_biometric_consent
            @identity_profile_requirements = identity_profile_requirements
          end

          def to_json(*_args)
            as_json.to_json
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
              required_documents: @required_documents.map(&:as_json),
              block_biometric_consent: @block_biometric_consent,
              identity_profile_requirements: @identity_profile_requirements
            }.compact
          end

          #
          # @return [SessionSpecificationBuilder]
          #
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

          #
          # Client-session-token time-to-live to apply to the created session
          #
          # @param [Integer] client_session_token_ttl
          #
          # @return [self]
          #
          def with_client_session_token_ttl(client_session_token_ttl)
            @client_session_token_ttl = client_session_token_ttl
            self
          end

          #
          # Time-to-live used for all Resources created in the course of the session
          #
          # @param [Integer] resources_ttl
          #
          # @return [self]
          #
          def with_resources_ttl(resources_ttl)
            @resources_ttl = resources_ttl
            self
          end

          #
          # User tracking id, for the Relying Business to track returning users
          #
          # @param [String] user_tracking_id
          #
          # @return [self]
          #
          def with_user_tracking_id(user_tracking_id)
            @user_tracking_id = user_tracking_id
            self
          end

          #
          # For configuring call-back messages
          #
          # @param [NotificationConfig] notifications
          #
          # @return [self]
          #
          def with_notifications(notifications)
            @notifications = notifications
            self
          end

          #
          # The check to be performed on each Document
          #
          # @param [RequestedCheck] requested_check
          #
          # @return [self]
          #
          def with_requested_check(requested_check)
            Validation.assert_is_a(RequestedCheck, requested_check, 'requested_check')
            @requested_checks.push(requested_check)
            self
          end

          #
          # The task to be performed on each Document
          #
          # @param [RequestedTask] requested_task
          #
          # @return [self]
          #
          def with_requested_task(requested_task)
            Validation.assert_is_a(RequestedTask, requested_task, 'requested_task')
            @requested_tasks.push(requested_task)
            self
          end

          #
          # The SDK configuration set on the session specification
          #
          # @param [SdkConfig] sdk_config
          #
          # @return [self]
          #
          def with_sdk_config(sdk_config)
            @sdk_config = sdk_config
            self
          end

          #
          # Adds a RequiredDocument to the list documents required from the client
          #
          # @param [RequiredDocument] required_document
          #
          # @return [self]
          #
          def with_required_document(required_document)
            Validation.assert_is_a(RequiredDocument, required_document, 'required_document')
            @required_documents.push(required_document)
            self
          end

          #
          # Whether or not to block the collection of biometric consent
          #
          # @param [Boolean] block_biometric_consent
          #
          # @return [self]
          #
          def with_block_biometric_consent(block_biometric_consent)
            @block_biometric_consent = block_biometric_consent
            self
          end

          #
          # Specify with_identity_profile_requirements
          #
          # @param [Hash] identity_profile_requirements
          #
          # @return [self]
          #
          def with_identity_profile_requirements(identity_profile_requirements)
            @identity_profile_requirements = identity_profile_requirements
            self
          end

          #
          # @return [SessionSpecification]
          #
          def build
            SessionSpecification.new(
              @client_session_token_ttl,
              @resources_ttl,
              @user_tracking_id,
              @notifications,
              @requested_checks,
              @requested_tasks,
              @sdk_config,
              @required_documents,
              @block_biometric_consent,
              @identity_profile_requirements
            )
          end
        end
      end
    end
  end
end
