# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Retrieve
        class CheckResponse
          attr_reader :type, :id, :state, :resources_used,
                      :generated_media, :report, :created, :last_updated

          def initialize(check)
            Validation.assert_is_a(String, check['type'], 'type', true)
            @type = check['type']

            Validation.assert_is_a(String, check['id'], 'id', true)
            @id = check['id']

            Validation.assert_is_a(String, check['state'], 'state', true)
            @state = check['state']

            Validation.assert_is_a(Array, check['resources_used'], 'resources_used', true)
            @resources_used = check['resources_used']

            if check['generated_media'].nil?
              @generated_media = []
            else
              Validation.assert_is_a(Array, check['generated_media'], 'generated_media')
              @generated_media = check['generated_media'].map { |media| GeneratedMedia.new(media) }
            end

            @report = ReportResponse.new(check['report']) unless check['report'].nil?
            @created = DateTime.parse(check['created']) unless check['created'].nil?
            @last_updated = DateTime.parse(check['last_updated']) unless check['last_updated'].nil?
          end
        end
      end
    end
  end
end
