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

          request = create_request
          request.http_method = 'POST'
          request.endpoint = 'sessions'
          request.payload = session_specification

          Yoti::DocScan::Session::Create::CreateSessionResult.new(JSON.parse(request.body))
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

          request = create_request
          request.http_method = 'GET'
          request.endpoint = "sessions/#{session_id}"

          Yoti::DocScan::Session::Retrieve::GetSessionResult.new(JSON.parse(request.body))
        end

        #
        # Deletes a previously created Yoti Doc Scan session and all
        # of its related resources
        #
        # @param [String] session_id
        #
        def delete_session(session_id)
          Validation.assert_is_a(String, session_id, 'session_id')

          request = create_request
          request.http_method = 'DELETE'
          request.endpoint = "sessions/#{session_id}"

          request.execute
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

          request = create_request
          request.http_method = 'GET'
          request.endpoint = "sessions/#{session_id}/media/#{media_id}"

          response = request.execute

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

          request = create_request
          request.http_method = 'DELETE'
          request.endpoint = "sessions/#{session_id}/media/#{media_id}"

          request.execute
        end

        #
        # Gets a list of supported documents.
        #
        # @return [Yoti::DocScan::Support::SupportedDocumentsResponse]
        #
        def supported_documents
          request = create_request
          request.http_method = 'GET'
          request.endpoint = 'supported-documents'

          Yoti::DocScan::Support::SupportedDocumentsResponse.new(JSON.parse(request.body))
        end

        private

        #
        # Create a base Doc Scan request
        #
        # @return [Yoti::Request]
        #
        def create_request
          request = Yoti::Request.new
          request.base_url = Yoti.configuration.doc_scan_api_endpoint
          request.query_params = { sdkId: Yoti.configuration.client_sdk_id }
          request
        end
      end
    end
  end
end
