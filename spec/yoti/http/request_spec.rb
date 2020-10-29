require 'spec_helper'

describe 'Yoti::Request' do
  let(:encrypted_connect_token) { File.read('spec/sample-data/encrypted_connect_token.txt', encoding: 'utf-8') }
  let(:request) { Yoti::Request.new }

  describe '#body', type: :api_empty do
    before(:each) do
      request.instance_variable_set(:@token, '')
    end

    context 'without a HTTP method' do
      it 'raises Yoti::RequestError' do
        error = 'The request requires a HTTP method.'
        expect { request.body }.to raise_error(Yoti::RequestError, error)
      end
    end

    context 'when the API call is unsuccessful', type: :api_error do
      let(:response_body) { File.read('spec/sample-data/responses/profile_error.json') }
      let(:error) { "Unsuccessful Yoti API call: Error: #{response_body}" }

      it 'raises Yoti::RequestError with response body appended to message' do
        request.http_method = 'GET'
        expect { request.body }.to raise_error(
          an_instance_of(Yoti::RequestError)
          .and(
            having_attributes(
              'message' => error,
              'response' => a_kind_of(Net::HTTPResponse)
            )
          )
        )
      end

      it 'raises Yoti::RequestError with response object' do
        request.http_method = 'GET'

        begin
          raise 'Request did not throw' if request.body
        rescue Yoti::RequestError => e
          expect(e.response.body).to eql(response_body)
        end
      end
    end

    context 'with a HTTP method', type: :api_empty do
      it 'returns the receipt value' do
        request.http_method = 'GET'
        expect(request.body).to eql('{}')
      end
    end
  end

  describe '#execute' do
    context 'with Hash payload' do
      before(:each) do
        stub_api_requests_v1(:post, 'empty', 'some-path', 201, { some: 'payload' }.to_json)
      end

      it 'returns successful response' do
        request.http_method = 'POST'
        request.endpoint = 'some-path'
        request.payload = { some: 'payload' }

        expect(request.body).to eql('{}')
      end
    end

    context 'with string payload' do
      before(:each) do
        stub_api_requests_v1(:post, 'empty', 'some-path', 201, 'some-string-payload')
      end

      it 'returns successful response' do
        request.http_method = 'POST'
        request.endpoint = 'some-path'
        request.payload = 'some-string-payload'

        expect(request.body).to eql('{}')
      end
    end

    context 'with query params' do
      before(:each) do
        stub_api_requests_v1(:get, 'empty', 'some-path?.*&some=param', 200)
      end

      it 'returns successful response' do
        request.http_method = 'GET'
        request.endpoint = 'some-path'
        request.query_params = { some: 'param' }

        expect(request.body).to eql('{}')
      end
    end

    context 'with token' do
      before(:each) do
        stub_api_requests_v1(:get, 'empty', "some-path/#{Yoti::SSL.decrypt_token(encrypted_connect_token)}", 200)
      end

      it 'returns successful response' do
        request.http_method = 'GET'
        request.endpoint = 'some-path'
        request.encrypted_connect_token = encrypted_connect_token

        expect(request.body).to eql('{}')
      end
    end
  end

  describe '#unsigned_request' do
    let(:unsigned_request) { request.send(:unsigned_request) }

    context 'with a valid HTTP method' do
      before(:each) do
        allow(request).to receive(:uri).and_return('uri')
      end

      it 'returns the a Get object' do
        request.http_method = 'GET'
        expect(unsigned_request).to be_a(Net::HTTP::Get)
      end

      it 'returns the a Delete object' do
        request.http_method = 'DELETE'
        expect(unsigned_request).to be_a(Net::HTTP::Delete)
      end

      it 'returns the a Post object' do
        request.http_method = 'POST'
        request.payload = { payload: 'fake_payload' }

        expect(unsigned_request).to be_a(Net::HTTP::Post)
        expect(unsigned_request.body).to eql('{"payload":"fake_payload"}')
      end

      it 'returns the a Put object' do
        request.http_method = 'PUT'
        request.payload = { payload: 'fake_payload' }

        expect(unsigned_request).to be_a(Net::HTTP::Put)
        expect(unsigned_request.body).to eql('{"payload":"fake_payload"}')
      end

      it 'returns the a Patch object' do
        request.http_method = 'PATCH'
        request.payload = { payload: 'fake_payload' }

        expect(unsigned_request).to be_a(Net::HTTP::Patch)
        expect(unsigned_request.body).to eql('{"payload":"fake_payload"}')
      end
    end

    context 'with an invalid HTTP method' do
      it 'raises Yoti::RequestError' do
        request.http_method = 'http_method'

        error = 'Request method not allowed: http_method'
        expect { unsigned_request }.to raise_error(Yoti::RequestError, error)
      end
    end
  end

  describe '#path' do
    it 'returns the profile request path' do
      request.endpoint = 'endpoint'
      request.payload = 'payload'

      allow(request).to receive(:token).and_return('random_token')
      allow(SecureRandom).to receive(:uuid).and_return('random_uuid')
      allow(Time).to receive(:now).and_return(1472743264)

      expect(request.send(:path)).to eql('/endpoint/random_token?nonce=random_uuid&timestamp=1472743264&appId=stub_yoti_client_sdk_id')
    end
  end
end
