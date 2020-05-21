# frozen_string_literal: true

module Yoti
  module DocScan
    class Client
      def self.create_session(session_specification)
        request = create_request
        request.http_method = 'POST'
        request.endpoint = 'sessions'
        request.payload = session_specification

        Yoti::DocScan::Session::Create::CreateSessionResult.new(JSON.parse(request.body))
      end

      def self.get_session(session_id)
        request = create_request
        request.http_method = 'GET'
        request.endpoint = "sessions/#{session_id}"

        Yoti::DocScan::Session::Retrieve::GetSessionResult.new(JSON.parse(request.body))
      end

      def self.delete_session(session_id)
        request = create_request
        request.http_method = 'DELETE'
        request.endpoint = "sessions/#{session_id}"

        request.execute
      end

      def self.get_media_content(session_id, media_id)
        request = create_request
        request.http_method = 'GET'
        request.endpoint = "sessions/#{session_id}/media/#{media_id}"

        response = request.execute

        Yoti::Media.new(
          response.body,
          response.get_fields('content-type')[0]
        )
      end

      def self.delete_media_content(session_id, media_id)
        request = create_request
        request.http_method = 'DELETE'
        request.endpoint = "sessions/#{session_id}/media/#{media_id}"

        request.execute
      end

      def self.supported_documents
        request = create_request
        request.http_method = 'GET'
        request.endpoint = 'supported-documents'

        Yoti::DocScan::Support::SupportedDocumentsResponse.new(JSON.parse(request.body))
      end

      private

      def self.create_request
        request = Yoti::Request.new
        request.base_url = Yoti.configuration.doc_scan_api_endpoint
        request.query_params = { sdkId: Yoti.configuration.client_sdk_id }
        request
      end
    end
  end
end
