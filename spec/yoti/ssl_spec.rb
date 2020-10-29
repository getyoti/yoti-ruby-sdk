require 'spec_helper'

describe 'Yoti::SSL' do
  before(:each) { clear_ssl }
  after(:each) { clear_ssl }

  describe '.pem' do
    let(:secret_key_path) { 'spec/sample-data/ruby-sdk-test.pem' }
    let(:secret_key_content) { File.read(secret_key_path, encoding: 'utf-8') }

    context 'when Yoti receives a string as a pem key' do
      before do
        Yoti.configuration.key = secret_key_content
      end

      it 'returns the secret key as a string' do
        expect(Yoti::SSL.pem).to eql(secret_key_content)
      end
    end

    context 'when Yoti receives a file as a pem key' do
      before do
        Yoti.configuration.key_file_path = secret_key_path
      end

      it 'returns the secret key as a string' do
        expect(Yoti::SSL.pem).to eql(secret_key_content)
      end
    end
  end

  describe '.decrypt_token' do
    let(:wrapped_key) { 'UqAI7cCcSFZ3NHWqEoXW3YfCXMxmvUBeN+JC2mQ/EVFvCjJ1DUVSzDP87bKtbZqKLqkj8oD0rQvMkS7VcYrUZ8aW6cTh+anX11LJLrP3ZYjr5QRQc5RHkOa+c3cFJV8ZwXzwJPkZny3BlHpEuAUhjcxywAcOPX4PULzO4zPrrkWq0cOtASVRqT+6CpR03RItL3yEY0CFa3RoYgrfkMsE8f8glft0GVVleVs85bAhiPmkfNQY0YZ/Ba12Ofph/S+4qB8ydfk96gpp+amb/Wfbd4gvs2DUCVpHu7U+937JEcEi6NJ08A5ufuWXoBxVKwVN1Tz7PNYDeSLhko77AIrJhg==' }

    context 'when the pem key is invalid' do
      before { Yoti::SSL.instance_variable_set(:@pem, 'invalid_pem') }

      it 'raises an SslError' do
        error = 'Could not decrypt token. The secure key is invalid. Neither PUB key nor PRIV key: not enough data'
        expect { Yoti::SSL.decrypt_token(wrapped_key) }.to raise_error(Yoti::SslError, error)
      end
    end

    context 'when the encrypted_connect_token is missing' do
      it 'raises an SslError' do
        error = 'Encrypted token cannot be nil.'
        expect { Yoti::SSL.decrypt_token(nil) }.to raise_error(Yoti::SslError, error)
      end
    end

    context 'when the encrypted_connect_token is invalid' do
      it 'raises an SslError' do
        invalid_wrapped_key = 'test key'
        error = 'Could not decrypt token. invalid base64'
        expect { Yoti::SSL.decrypt_token(invalid_wrapped_key) }.to raise_error(Yoti::SslError, error)
      end
    end

    context 'when the encrypted_connect_token is valid' do
      it 'decrypts a base64 string with a private key,' do
        unwrapped_key = Yoti::SSL.decrypt_token(wrapped_key)
        expect(Base64.strict_encode64(unwrapped_key)).to eql('n3+pR/DwwV9noVJz/gyWKyJZoYPkvX7Oahf/mDnfDEE=')
      end
    end
  end

  describe '.auth_key_from_pem' do
    it 'extracts the auth token from the pem file' do
      key_from_pem = Yoti::SSL.auth_key_from_pem
      expect(key_from_pem).to eql('MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9zAY5K9O92zfmRhxBO0NX8Dg7UyyIaLE5GdbCMimlccew2p8LN6P8EDUoU7hiCbW1EQ/cp4iZVIp7UPA3AO/ecuejs2DjkFQOeMGnSlwD0pk74ZI3ammQtYm2ml47IWGrciMh4dPIPh0SOF+tVD0kHhAB9cMaj96Ij2De60Y7SeqvIXUHCtnoHId7Zk5I71mtewAnb9Gpx+wPnr2gpX/uUqkh+3ZHsF2eNCpw/ICvKj4UkNXopUyBemDp3n/s7u8TFyewp7ipPbFxDmxZKJT9SjZNFFe/jc2V/R2uC9qSFRKpTsxqmXggjiBlH46cpyg2SeYFj1p5bkpKZ10b3iOwIDAQAB')
    end
  end

  describe '.get_secure_signature' do
    it 'generates secure random token' do
      token = Yoti::SSL.get_secure_signature('message')
      expect(token).to eql('Dvk2DCW/5/pNwkhDoHG/qaf/vl1RR/lFIldw6ms3yVOe7TStnX9EJupfewprehHQ6XhkxfoCCb+VTWGtQHRkuZB/CotJ5sSsc28HYokMvq2Mz7mD47gx5pEXqtb9s22v0eOUELTcbCmaQg8HPk3kBcvRWbyMjY7cJhI44METHxOjhN/9AEdlNU+96K7nJe7QxgQNX5Q/dKsIawD0UabT/qGBFLtic3j9+XACnM+ZTcJIYs6OXpPfXhHkekKvLVpT/EBx1KTK6XXr5NYI7f5pawIHtwx2B0oy2uqxu/trKEw6opJ3yUoN1JqbCRMIHUdIHzi0Mdz6LY05689+224/ww==')
    end
  end

  describe '.decipher' do
    text = 'cipher text'
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    let(:key) { cipher.random_key }
    let(:iv) { cipher.random_iv }
    let(:ciphered_text) { cipher.update(text) + cipher.final }

    it 'decrypts the ciphered text using the key and iv' do
      expect(Yoti::SSL.decipher(key, iv, ciphered_text)).to eql('cipher text')
    end
  end

  describe '.reload' do
    let(:some_key) { 'some-key' }
    let(:some_other_key) { 'some-other-key' }
    it 'should reset pem' do
      Yoti.configuration.key = some_key
      expect(Yoti::SSL.pem).to eql(some_key)

      Yoti.configuration.key = some_other_key
      expect(Yoti::SSL.pem).to eql(some_key)

      Yoti::SSL.reload!
      expect(Yoti::SSL.pem).to eql(some_other_key)
    end
  end
end
