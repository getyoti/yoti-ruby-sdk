require 'spec_helper'

describe 'Yoti::Request' do
  let(:encrypted_connect_token) { File.read('spec/fixtures/encrypted_connect_token.txt', encoding: 'utf-8') }
  let(:request) { Yoti::Request.new }

  describe '#receipt', type: :api_empty do
    before(:each) do
      request.instance_variable_set(:@token, '')
    end

    context 'without a HTTP method' do
      it 'raises Yoti::RequestError' do
        error = 'The request requires a HTTP method.'
        expect { request.receipt }.to raise_error(Yoti::RequestError, error)
      end
    end

    context 'with an invalid payload' do
      it 'raises Yoti::RequestError' do
        request.http_method = 'GET'
        request.payload = 'payload'

        error = 'The payload needs to be a hash.'
        expect { request.receipt }.to raise_error(Yoti::RequestError, error)
      end
    end

    context 'when the API call is unsuccessful', type: :api_error do
      it 'raises Yoti::RequestError' do
        request.http_method = 'GET'

        error = 'Unsuccessful Yoti API call: Error'
        expect { request.receipt }.to raise_error(Yoti::RequestError, error)
      end
    end

    context 'with a HTTP method and a valid payload', type: :api_empty do
      it 'returns the receipt value' do
        request.http_method = 'GET'
        expect(request.receipt).to eql({})
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
        expect(unsigned_request.body).to eql('payload=fake_payload')
      end

      it 'returns the a Put object' do
        request.http_method = 'PUT'
        request.payload = { payload: 'fake_payload' }

        expect(unsigned_request).to be_a(Net::HTTP::Put)
        expect(unsigned_request.body).to eql('payload=fake_payload')
      end

      it 'returns the a Patch object' do
        request.http_method = 'PATCH'
        request.payload = { payload: 'fake_payload' }

        expect(unsigned_request).to be_a(Net::HTTP::Patch)
        expect(unsigned_request.body).to eql('payload=fake_payload')
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
