require 'spec_helper'

describe 'Yoti::Request' do
  let(:encrypted_yoti_token) { File.read('spec/fixtures/encrypted_yoti_token.txt', encoding: 'utf-8') }
  let(:http_method) { 'HTTP_METHOD' }
  let(:endpoint) { 'endpoint' }
  let(:request) { Yoti::Request.new(encrypted_yoti_token, http_method, endpoint) }

  describe '#initialize' do
    it 'saves the instance variables' do
      expect(request.instance_variable_get(:@encrypted_connect_token)).to eql(encrypted_yoti_token)
      expect(request.instance_variable_get(:@http_method)).to eql('HTTP_METHOD')
      expect(request.instance_variable_get(:@endpoint)).to eql('endpoint')
    end
  end

  describe '#receipt', type: :api_empty do
    it 'returns an empty Hash' do
      expect(request.receipt).to be_empty
    end
  end

  describe '#path' do
    it 'returns the profile request path' do
      allow(request).to receive(:token).and_return('random_token')
      allow(SecureRandom).to receive(:uuid).and_return('random_uuid')
      allow(Time).to receive(:now).and_return(1472743264)

      expect(request.send(:path)).to eql('/endpoint/random_token?nonce=random_uuid&timestamp=1472743264&appId=stub_yoti_client_sdk_id')
    end
  end
end
