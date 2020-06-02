require 'spec_helper'

describe 'Yoti::ProfileRequest' do
  let(:encrypted_connect_token) { File.read('spec/sample-data/encrypted_connect_token.txt', encoding: 'utf-8') }
  let(:profile_request) { Yoti::ProfileRequest.new(encrypted_connect_token) }

  describe '#initialize' do
    it 'sets the instance variable @encrypted_connect_token' do
      expect(profile_request.instance_variable_get(:@encrypted_connect_token)).to eql(encrypted_connect_token)
    end

    let(:yoti_request) { profile_request.instance_variable_get(:@request) }

    it 'sets the X-Yoti-Auth-Key header' do
      expect(yoti_request.instance_variable_get(:@headers)['X-Yoti-Auth-Key']).to eql 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9zAY5K9O92zfmRhxBO0NX8Dg7UyyIaLE5GdbCMimlccew2p8LN6P8EDUoU7hiCbW1EQ/cp4iZVIp7UPA3AO/ecuejs2DjkFQOeMGnSlwD0pk74ZI3ammQtYm2ml47IWGrciMh4dPIPh0SOF+tVD0kHhAB9cMaj96Ij2De60Y7SeqvIXUHCtnoHId7Zk5I71mtewAnb9Gpx+wPnr2gpX/uUqkh+3ZHsF2eNCpw/ICvKj4UkNXopUyBemDp3n/s7u8TFyewp7ipPbFxDmxZKJT9SjZNFFe/jc2V/R2uC9qSFRKpTsxqmXggjiBlH46cpyg2SeYFj1p5bkpKZ10b3iOwIDAQAB'
    end

    it 'sets the instance variable @request' do
      expect(yoti_request).to be_a(Yoti::Request)

      expect(yoti_request.http_method).to eql('GET')
      expect(yoti_request.endpoint).to eql("profile/#{Yoti::SSL.decrypt_token(encrypted_connect_token)}")
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
