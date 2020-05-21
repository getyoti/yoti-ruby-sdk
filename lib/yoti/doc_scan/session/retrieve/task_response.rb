# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class TaskResponse
          # @return [String]
          attr_reader :type

          # @return [String]
          attr_reader :id

          # @return [String]
          attr_reader :state

          # @return [Array<String>]
          attr_reader :resources_used

          # @return [Array<GeneratedMedia>]
          attr_reader :generated_media

          # @return [Array<GeneratedCheckResponse>]
          attr_reader :generated_checks

          # @return [<DateTime>]
          attr_reader :created

          # @return [<DateTime>]
          attr_reader :last_updated

          #
          # @param [Hash] task
          #
          def initialize(task)
            Validation.assert_is_a(String, task['type'], 'type', true)
            @type = task['type']

            Validation.assert_is_a(String, task['id'], 'id', true)
            @id = task['id']

            Validation.assert_is_a(String, task['state'], 'state', true)
            @state = task['state']

            Validation.assert_is_a(Array, task['resources_used'], 'resources_used', true)
            @resources_used = task['resources_used']

            @created = DateTime.parse(task['created']) unless task['created'].nil?
            @last_updated = DateTime.parse(task['last_updated']) unless task['last_updated'].nil?

            if task['generated_checks'].nil?
              @generated_checks = []
            else
              Validation.assert_is_a(Array, task['generated_checks'], 'generated_checks')
              @generated_checks = map_generated_checks(task['generated_checks'])
            end

            if task['generated_media'].nil?
              @generated_media = []
            else
              Validation.assert_is_a(Array, task['generated_media'], 'generated_media')
              @generated_media = task['generated_media'].map { |media| GeneratedMedia.new(media) }
            end
          end

          private

          #
          # @param [Array<Hash>] generated_checks
          #
          # @return [Array<GeneratedCheckResponse>]
          #
          def map_generated_checks(generated_checks)
            generated_checks.map do |check|
              case check['type']
              when Constants::ID_DOCUMENT_TEXT_DATA_CHECK
                GeneratedTextDataCheckResponse.new(check)
              else
                GeneratedCheckResponse.new(check)
              end
            end
          end
        end
      end
    end
  end
end
