require 'spec_helper'

describe 'Yoti::ProfileRequest' do
  let(:encrypted_connect_token) { File.read('spec/fixtures/encrypted_connect_token.txt', encoding: 'utf-8') }
  let(:profile_request) { Yoti::ProfileRequest.new(encrypted_connect_token) }

  describe '#initialize' do
    it 'sets the instance variable @encrypted_connect_token' do
      expect(profile_request.instance_variable_get(:@encrypted_connect_token)).to eql(encrypted_connect_token)
    end

    let(:yoti_request) { profile_request.instance_variable_get(:@request) }

    it 'sets the instance variable @request' do
      expect(yoti_request).to be_a(Yoti::Request)

      expect(yoti_request.encrypted_connect_token).to eql(encrypted_connect_token)
      expect(yoti_request.http_method).to eql('GET')
      expect(yoti_request.endpoint).to eql('profile')
    end
  end

  describe '#receipt', type: :api_with_profile do
    it 'returns a Hash with the receipt keys' do
      expect(profile_request.receipt.key?('other_party_profile_content')).to be true
      expect(profile_request.receipt.key?('remember_me_id')).to be true
      expect(profile_request.receipt.key?('sharing_outcome')).to be true
    end
  end
end
