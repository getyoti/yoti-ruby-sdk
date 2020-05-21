# frozen_string_literal: true

require 'spec_helper'

def stub_doc_scan_api_request(
  method: :get,
  endpoint: '[a-zA-Z]*',
  response_body: '{}',
  status: 200,
  request_body: nil
)
  stub = stub_request(method, %r{https:\/\/api.yoti.com\/idverify\/v1\/#{endpoint}(.)*})
  stub.with(body: request_body) unless request_body.nil?
  stub.to_return(
    status: status,
    body: response_body,
    headers: { 'Content-Type' => 'application/json' }
  )
end

describe 'Yoti::DocScan::Client' do
  context '.create_session' do
    before(:context) do
      stub_doc_scan_api_request(method: :post, endpoint: 'sessions')
    end

    it 'creates a create session result' do
      some_sdk_config = Yoti::DocScan::Session::Create::SdkConfig
                        .builder
                        .with_allows_camera
                        .build

      some_notification_config = Yoti::DocScan::Session::Create::NotificationConfig
                                 .builder
                                 .with_endpoint('https://www.example.com/some-endpoint')
                                 .for_task_completion
                                 .build

      some_authenticity_check = Yoti::DocScan::Session::Create::RequestedDocumentAuthenticityCheck
                                .builder
                                .build

      spec = Yoti::DocScan::Session::Create::SessionSpecification
             .builder
             .with_client_session_token_ttl(400)
             .with_resources_ttl(86840)
             .with_user_tracking_id('some-tracking-id')
             .with_sdk_config(some_sdk_config)
             .with_requested_check(some_authenticity_check)
             .with_notifications(some_notification_config)
             .build

      result = Yoti::DocScan::Client.create_session(spec)

      expect(result).to be_a(Yoti::DocScan::Session::Create::CreateSessionResult)
    end
  end

  context '.get_session' do
    before(:context) do
      stub_doc_scan_api_request(method: :get, endpoint: 'sessions/some-id')
    end

    it 'gets a session result' do
      result = Yoti::DocScan::Client.get_session('some-id')

      expect(result).to be_a(Yoti::DocScan::Session::Retrieve::GetSessionResult)
    end
  end

  context '.delete_session' do
    before(:context) do
      stub_doc_scan_api_request(method: :delete, endpoint: 'sessions/some-id')
    end

    it 'deletes a session' do
      expect { Yoti::DocScan::Client.delete_session('some-id') }.not_to raise_error
    end
  end

  context '.get_media_content' do
    before(:context) do
      stub_doc_scan_api_request(method: :get, endpoint: 'sessions/some-id/media/some-media-id')
    end

    it 'gets media content' do
      media = Yoti::DocScan::Client.get_media_content('some-id', 'some-media-id')

      expect(media).to be_a(Yoti::Media)
      expect(media.content).to be('{}')
      expect(media.mime_type).to be('application/json')
    end
  end

  context '.delete_media_content' do
    before(:context) do
      stub_doc_scan_api_request(method: :delete, endpoint: 'sessions/some-id/media/some-media-id')
    end

    it 'deletes media content' do
      expect { Yoti::DocScan::Client.delete_media_content('some-id', 'some-media-id') }.not_to raise_error
    end
  end

  context '.supported_documents' do
    before(:context) do
      stub_doc_scan_api_request(method: :get, endpoint: 'supported-documents')
    end

    it 'gets supported documents' do
      documents = Yoti::DocScan::Client.supported_documents

      expect(documents).to be_a(Yoti::DocScan::Support::SupportedDocumentsResponse)
    end
  end
end
