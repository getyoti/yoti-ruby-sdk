require 'spec_helper'

describe 'Yoti::Request' do
  let(:encrypted_yoti_token) { File.read('spec/fixtures/encrypted_yoti_token.txt', encoding: 'utf-8') }
  let(:request) { Yoti::Request.new(encrypted_yoti_token) }

  describe '#initialize' do
    it 'saves the encrypted token as an instance variable ' do
      expect(request.instance_variable_get(:@encrypted_connect_token)).to eql(encrypted_yoti_token)
    end
  end

  describe '#receipt', type: :api_with_profile do
    it 'returns a Hash with the required keys' do
      expect(request.receipt.key?('other_party_profile_content')).to be true
      expect(request.receipt.key?('remember_me_id')).to be true
      expect(request.receipt.key?('sharing_outcome')).to be true
    end
  end

  describe '#path' do
    it 'returns the profile request path' do
      allow(request).to receive(:token).and_return('random_token')
      allow(SecureRandom).to receive(:uuid).and_return('random_uuid')
      allow(Time).to receive(:now).and_return(1472743264)

      expect(request.send(:path)).to eql('/profile/random_token?nonce=random_uuid&timestamp=1472743264&appId=stub_yoti_client_sdk_id')
    end
  end
end
