require 'spec_helper'

describe 'Yoti::ProfileRequest' do
  let(:encrypted_yoti_token) { File.read('spec/fixtures/encrypted_yoti_token.txt', encoding: 'utf-8') }
  let(:profile_request) { Yoti::ProfileRequest.receipt(encrypted_yoti_token) }

  describe '.receipt', type: :api_with_profile do
    it 'returns a Hash with the required keys' do
      expect(profile_request.key?('other_party_profile_content')).to be true
      expect(profile_request.key?('remember_me_id')).to be true
      expect(profile_request.key?('sharing_outcome')).to be true
    end
  end
end
