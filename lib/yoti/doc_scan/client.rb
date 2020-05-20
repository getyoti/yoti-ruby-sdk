# frozen_string_literal: true

module Yoti
  module DocScan
    class Client
      def self.create_session(session_specification)
        request = Yoti::Request.new
        request.http_method = 'POST'
        request.endpoint = 'sessions'
        request.payload = session_specification
        request.base_url = Yoti.configuration.doc_scan_api_endpoint
        request.query_params = { sdkId: Yoti.configuration.client_sdk_id }

        begin
          Yoti::DocScan::Session::Create::CreateSessionResult.new(JSON.parse(request.body))
        rescue Yoti::RequestError => e
          raise RequestError.new(e.message, e.response)
        end
      end
    end
  end
end
