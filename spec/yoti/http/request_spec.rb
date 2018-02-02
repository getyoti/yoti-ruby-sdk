require 'spec_helper'

describe 'Yoti::Request' do
  let(:encrypted_yoti_token) { File.read('spec/fixtures/encrypted_yoti_token.txt', encoding: 'utf-8') }
  let(:request) { Yoti::Request.new }

  describe '#initialize' do
    it 'sets the instance variables' do
      request.encrypted_connect_token = 'encrypted_connect_token'
      request.http_method = 'GET'
      request.endpoint = 'endpoint'
      request.payload = 'payload'

      expect(request.encrypted_connect_token).to eql('encrypted_connect_token')
      expect(request.http_method).to eql('GET')
      expect(request.endpoint).to eql('endpoint')
      expect(request.instance_variable_get(:@auth_key)).to be_a String
    end
  end

  describe '#receipt', type: :api_empty do
    before(:each) do
      request.instance_variable_set(:@token, '')
    end

    context 'with a valid HTTP GET, DELETE method' do
      it 'returns an empty receipt Hash' do
        %w[GET DELETE].each do |method|
          request.http_method = method
          expect(request.receipt).to be_empty
        end
      end
    end

    context 'with a valid HTTP POST, PUT, PATCH method' do
      it 'returns an empty receipt Hash' do
        request.payload = { payload: 'payload' }
        %w[POST PUT PATCH].each do |method|
          request.http_method = method
          expect(request.receipt).to be_empty
        end
      end
    end

    context 'with an invalid HTTP method' do
      it 'raises Yoti::RequestError' do
        request.http_method = 'http_method'

        error = 'Request method not allowed: http_method'
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
  end

  describe '#path' do
    it 'returns the profile request path' do
      request.endpoint = 'endpoint'
      request.payload = 'payload'

      allow(request).to receive(:token).and_return('random_token')
      allow(SecureRandom).to receive(:uuid).and_return('random_uuid')
      allow(Time).to receive(:now).and_return(1472743264)

      expect(request.send(:path)).to eql('/endpoint/random_token?nonce=random_uuid&timestamp=1472743264&appId=stub_yoti_client_sdk_id&BAhbFmkJaQ1pTmknaRFpdWlmaX5pcWl0aWZpaWkLaT9pC2lKaVk=')
    end
  end
end
