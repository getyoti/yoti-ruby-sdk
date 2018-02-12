require 'spec_helper'

describe 'Yoti::SignedRequest' do
  let(:encrypted_connect_token) { File.read('spec/fixtures/encrypted_connect_token.txt', encoding: 'utf-8') }
  let(:payload_aml) { JSON.parse(File.read('spec/fixtures/payloads/aml_check.json', encoding: 'utf-8')) }
  let(:unsigned_request) { Net::HTTP::Get.new('uri') }
  let(:signed_request) { Yoti::SignedRequest.new(unsigned_request, 'path') }

  describe '#initialize' do
    it 'sets the instance variables' do
      expect(signed_request.instance_variable_get(:@http_req)).to be_a(Net::HTTP::Get)
      expect(signed_request.instance_variable_get(:@path)).to eql('path')
      expect(signed_request.instance_variable_get(:@payload)).to eql({})
      expect(signed_request.instance_variable_get(:@auth_key)).to be_a String
    end
  end

  describe '#sign' do
    let(:signed) { signed_request.send(:sign) }
    it 'return a signed request' do
      expect(signed).to be_a(Net::HTTP::Get)
      expect(signed['X-Yoti-Auth-Key']).to eql('MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9zAY5K9O92zfmRhxBO0NX8Dg7UyyIaLE5GdbCMimlccew2p8LN6P8EDUoU7hiCbW1EQ/cp4iZVIp7UPA3AO/ecuejs2DjkFQOeMGnSlwD0pk74ZI3ammQtYm2ml47IWGrciMh4dPIPh0SOF+tVD0kHhAB9cMaj96Ij2De60Y7SeqvIXUHCtnoHId7Zk5I71mtewAnb9Gpx+wPnr2gpX/uUqkh+3ZHsF2eNCpw/ICvKj4UkNXopUyBemDp3n/s7u8TFyewp7ipPbFxDmxZKJT9SjZNFFe/jc2V/R2uC9qSFRKpTsxqmXggjiBlH46cpyg2SeYFj1p5bkpKZ10b3iOwIDAQAB')
      expect(signed['X-Yoti-Auth-Digest']).to eql('X4iPrpUNUXDFbdRWiWjh87P7TOq5sPmPYCaNGsbqsB5EDnsuFi+kG2yeYFBJiUpcvm5QogseXMlBY6pxUD6d1AZv1ftllAp5nA2RcpUBbCvvYneJC8f+MYMxw01pl2i3Xz7FlbEB633PnMaJLOnaXtMTzZgdP1GPzbsjjOLiUxMyeCUonkz700PuKCdHQfI339OmUZUrPKZe3WrKLlqcYEbJFdSIxGo8vnzi7sFoUkWV6gmp5vlfreMfm6mpQbJcomgoyCUQInF3MgeMKetj7V+wifZW0nLI5evZSffUcXvX/0pbJUR9gl41NU8VpXGSVru+7iilT8ytJd0WGNlWjw==')
      expect(signed['X-Yoti-SDK']).to eql('Ruby')
      expect(signed['Content-Type']).to eql('application/json')
      expect(signed['Accept']).to eql('application/json')
    end
  end

  describe '#payload_string' do
    let(:payload_string) { signed_request.send(:payload_string) }

    context 'without a payload' do
      it 'returns an empty string' do
        signed_request.instance_variable_set(:@payload, nil)
        expect(payload_string).to be_empty
      end
    end

    context 'witha payload' do
      it 'returns a base64 encoded string' do
        signed_request.instance_variable_set(:@payload, payload_aml)
        expect(payload_string).to eql('&eyJnaXZlbl9uYW1lcyI6IiIsImZhbWlseV9uYW1lIjoiIiwic3NuIjoiIiwiYWRkcmVzcyI6eyJwb3N0X2NvZGUiOiIiLCJjb3VudHJ5IjoiIn19')
      end
    end
  end
end
