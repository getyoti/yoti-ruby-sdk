# frozen_string_literal: true

require 'spec_helper'

def stub_doc_scan_api_request(
  method: :get,
  endpoint: '[a-zA-Z]*',
  response_body: '{}',
  status: 200,
  request_body: nil,
  query: nil,
  headers: { 'Content-Type' => 'application/json' }
)
  stub = stub_request(method, %r{https://api.yoti.com/idverify/v1/#{endpoint}})
  stub.with(body: request_body) unless request_body.nil?
  stub.with(query: query) unless query.nil?
  stub.to_return(
    status: status,
    body: response_body,
    headers: headers
  )
end

describe 'Yoti::DocScan::Client' do
  describe '.create_session' do
    let(:spec) do
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

      Yoti::DocScan::Session::Create::SessionSpecification
        .builder
        .with_client_session_token_ttl(400)
        .with_resources_ttl(86840)
        .with_user_tracking_id('some-tracking-id')
        .with_sdk_config(some_sdk_config)
        .with_requested_check(some_authenticity_check)
        .with_notifications(some_notification_config)
        .build
    end

    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(method: :post, endpoint: 'sessions')
      end

      it 'creates a create session result' do
        result = Yoti::DocScan::Client.create_session(spec)

        expect(result).to be_a(Yoti::DocScan::Session::Create::CreateSessionResult)
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(method: :post, endpoint: 'sessions', status: 400)
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.create_session(spec) }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end

  describe '.get_session' do
    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'sessions/some-id\?nonce=.*&sdkId=.*&timestamp=.*',
          query: hash_including(
            sdkId: Yoti.configuration.client_sdk_id,
            nonce: /.*/,
            timestamp: /.*/
          )
        )
      end

      it 'gets a session result' do
        result = Yoti::DocScan::Client.get_session('some-id')

        expect(result).to be_a(Yoti::DocScan::Session::Retrieve::GetSessionResult)
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'sessions/some-id',
          status: 400
        )
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.get_session('some-id') }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end

  describe '.delete_session' do
    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :delete,
          endpoint: 'sessions/some-id',
          query: hash_including(
            sdkId: Yoti.configuration.client_sdk_id,
            nonce: /.*/,
            timestamp: /.*/
          )
        )
      end

      it 'deletes a session' do
        expect { Yoti::DocScan::Client.delete_session('some-id') }.not_to raise_error
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :delete,
          endpoint: 'sessions/some-id',
          status: 400
        )
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.delete_session('some-id') }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end

  describe '.get_media_content' do
    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'sessions/some-id/media/some-media-id/content',
          query: hash_including(
            sdkId: Yoti.configuration.client_sdk_id,
            nonce: /.*/,
            timestamp: /.*/
          )
        )
      end

      it 'gets media content' do
        media = Yoti::DocScan::Client.get_media_content('some-id', 'some-media-id')

        expect(media).to be_a(Yoti::Media)
        expect(media.content).to be('{}')
        expect(media.mime_type).to be('application/json')
      end
    end

    context 'when response has no content' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          status: 204,
          headers: {},
          endpoint: 'sessions/some-id/media/some-media-id/content'
        )
      end

      it 'returns nil' do
        media = Yoti::DocScan::Client.get_media_content('some-id', 'some-media-id')

        expect(media).to be_nil
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'sessions/some-id/media/some-media-id/content',
          status: 400
        )
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.get_media_content('some-id', 'some-media-id') }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end

  describe '.delete_media_content' do
    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :delete,
          endpoint: 'sessions/some-id/media/some-media-id/content',
          query: hash_including(
            sdkId: Yoti.configuration.client_sdk_id,
            nonce: /.*/,
            timestamp: /.*/
          )
        )
      end

      it 'deletes media content' do
        expect { Yoti::DocScan::Client.delete_media_content('some-id', 'some-media-id') }.not_to raise_error
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :delete,
          endpoint: 'sessions/some-id/media/some-media-id/content',
          status: 400
        )
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.delete_media_content('some-id', 'some-media-id') }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end

  describe '.supported_documents' do
    context 'when response is success' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'supported-documents',
          query: hash_including(
            nonce: /.*/,
            timestamp: /.*/
          )
        )
      end

      it 'gets supported documents' do
        documents = Yoti::DocScan::Client.supported_documents

        expect(documents).to be_a(Yoti::DocScan::Support::SupportedDocumentsResponse)
      end
    end

    context 'when response is failure' do
      before(:context) do
        stub_doc_scan_api_request(
          method: :get,
          endpoint: 'supported-documents',
          status: 400
        )
      end

      it 'raises Yoti::DocScan::Error' do
        expect { Yoti::DocScan::Client.supported_documents }
          .to raise_error(Yoti::DocScan::Error)
      end
    end
  end
end
