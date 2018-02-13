require 'spec_helper'

describe 'Yoti::SignedRequest' do
  let(:encrypted_connect_token) { File.read('spec/fixtures/encrypted_connect_token.txt', encoding: 'utf-8') }
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
      expect(signed['X-Yoti-Auth-Digest']).to eql('UmOFC+aF7W0EA+Nb6KvWzW0js8NaexNdVanEZ4b7qmsn4XD3glZcmII59RjQ583n3/Gyd6vdqFHrYU1Cwxy+sbyFMieAkc9OjKNA9sanBdI1owxO4ElO8Ch6g6Ww3a0mTri5RObJT6JaYbpJxoteLhibzUL+EFAI76qeALcAEhXhqjkbrmB5kiaqjVAYZwk7vmz6OVxAHiCIr+kJ1/qgvZUyU6pSdDHnFoB0k5hMMuUpOu6PirSRG8imMBYhhG4gBMQbV19FKdnVbFJAZXOe7F5Ir7r+EGRoV4le7RCPscE2OE4EByrYzzKv5TQ1Gj823haSYTs+/TeUl5x06ntONw==')
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
        signed_request.instance_variable_set(:@payload, payload: 'payload')
        expect(payload_string).to eql('&BAhbIWkJaQ1pAXtpC2k/aRFpdWlmaX5pcWl0aWZpaWlOaSdpEWl1aWZpfmlxaXRpZmlpaQtpP2kLaUppWQ==')
      end
    end
  end
end
