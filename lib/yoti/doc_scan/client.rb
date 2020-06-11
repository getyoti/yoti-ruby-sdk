# frozen_string_literal: true

module Yoti
  module DocScan
    class Client
      class << self
        #
        # Creates a Doc Scan session using the supplied session specification
        #
        # @param [Yoti::DocScan::Session::Create::SessionSpecification] session_specification
        #
        # @return [Yoti::DocScan::Session::Create::CreateSessionResult]
        #
        def create_session(session_specification)
          Validation.assert_is_a(
            Yoti::DocScan::Session::Create::SessionSpecification,
            session_specification,
            'session_specification'
          )

          response = create_request
                     .with_http_method('POST')
                     .with_endpoint('sessions')
                     .with_payload(session_specification)
                     .with_query_param('sdkId', Yoti.configuration.client_sdk_id)
                     .build
                     .execute

          Yoti::DocScan::Session::Create::CreateSessionResult.new(JSON.parse(response.body))
        end

        #
        # Retrieves the state of a previously created Yoti Doc Scan session
        #
        # @param [String] session_id
        #
        # @return [Yoti::DocScan::Session::Retrieve::GetSessionResult]
        #
        def get_session(session_id)
          Validation.assert_is_a(String, session_id, 'session_id')

          response = create_request
                     .with_http_method('GET')
                     .with_endpoint(session_path(session_id))
                     .with_query_param('sdkId', Yoti.configuration.client_sdk_id)
                     .build
                     .execute

          Yoti::DocScan::Session::Retrieve::GetSessionResult.new(JSON.parse(response.body))
        end

        #
        # Deletes a previously created Yoti Doc Scan session and all
        # of its related resources
        #
        # @param [String] session_id
        #
        def delete_session(session_id)
          Validation.assert_is_a(String, session_id, 'session_id')

          create_request
            .with_http_method('DELETE')
            .with_endpoint(session_path(session_id))
            .with_query_param('sdkId', Yoti.configuration.client_sdk_id)
            .build
            .execute
        end

        #
        # Retrieves media related to a Yoti Doc Scan session based
        # on the supplied media ID
        #
        # @param [String] session_id
        # @param [String] media_id
        #
        # @return [Yoti::Media]
        #
        def get_media_content(session_id, media_id)
          Validation.assert_is_a(String, session_id, 'session_id')
          Validation.assert_is_a(String, media_id, 'media_id')

          response = create_request
                     .with_http_method('GET')
                     .with_endpoint(media_path(session_id, media_id))
                     .with_query_param('sdkId', Yoti.configuration.client_sdk_id)
                     .build
                     .execute

          Yoti::Media.new(
            response.body,
            response.get_fields('content-type')[0]
          )
        end

        #
        # Deletes media related to a Yoti Doc Scan session based
        # on the supplied media ID
        #
        # @param [String] session_id
        # @param [String] media_id
        #
        def delete_media_content(session_id, media_id)
          Validation.assert_is_a(String, session_id, 'session_id')
          Validation.assert_is_a(String, media_id, 'media_id')

          create_request
            .with_http_method('DELETE')
            .with_endpoint(media_path(session_id, media_id))
            .with_query_param('sdkId', Yoti.configuration.client_sdk_id)
            .build
            .execute
        end

        #
        # Gets a list of supported documents.
        #
        # @return [Yoti::DocScan::Support::SupportedDocumentsResponse]
        #
        def supported_documents
          response = create_request
                     .with_http_method('GET')
                     .with_endpoint('supported-documents')
                     .build
                     .execute

          Yoti::DocScan::Support::SupportedDocumentsResponse.new(JSON.parse(response.body))
        end

        private

        #
        # @param [String] session_id
        #
        # @return [String]
        #
        def session_path(session_id)
          "sessions/#{session_id}"
        end

        #
        # @param [String] session_id
        # @param [String] media_id
        #
        # @return [String]
        #
        def media_path(session_id, media_id)
          "#{session_path(session_id)}/media/#{media_id}/content"
        end

        #
        # Create a base Doc Scan request
        #
        # @return [Yoti::Request]
        #
        def create_request
          Yoti::Request
            .builder
            .with_base_url(Yoti.configuration.doc_scan_api_endpoint)
        end
      end
    end
  end
end
