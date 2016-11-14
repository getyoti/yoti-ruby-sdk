require 'spec_helper'

describe 'Yoti::SSL' do
  before(:each) { clear_ssl }
  after(:each) { clear_ssl }

  describe '.pem' do
    SECRET_KEY = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAs9zAY5K9O92zfmRhxBO0NX8Dg7UyyIaLE5GdbCMimlccew2p\n8LN6P8EDUoU7hiCbW1EQ/cp4iZVIp7UPA3AO/ecuejs2DjkFQOeMGnSlwD0pk74Z\nI3ammQtYm2ml47IWGrciMh4dPIPh0SOF+tVD0kHhAB9cMaj96Ij2De60Y7SeqvIX\nUHCtnoHId7Zk5I71mtewAnb9Gpx+wPnr2gpX/uUqkh+3ZHsF2eNCpw/ICvKj4UkN\nXopUyBemDp3n/s7u8TFyewp7ipPbFxDmxZKJT9SjZNFFe/jc2V/R2uC9qSFRKpTs\nxqmXggjiBlH46cpyg2SeYFj1p5bkpKZ10b3iOwIDAQABAoIBACr0ue4OCavWkxvI\nlaDio9Ny9j/qcqp5l5Wg3VwKOCVsUJ0C8mdONhAr5MM8lq698tyoS8qRJKCXSrbj\nAybrCGmTYQJISeyzqZGKu2dGHKAA+4ERkadqmvdKQms7nCb5TVYsDrqxfoIJbVEp\njsINVRlOKpKA6t/hYGK88yb4r5RwFB7t0qwLQRbI8MajTWmgk9SKFjSiOnFH5+Dl\nZiNDa39mHwY4fu9ZKjenZDq04/eh32mZSUkyQ4V3exqz/Xugl++mcBq9KIv1M489\nU4a1hXV+0biAuro6lgvyquHSKpYx9n1verjcBa5J0AWQhnwS2lcsfQIRssV8W0gd\nSVdd7QECgYEA4pVr7haKz+2p2GJpzCFGtI5T4FBS+1cCDDX0oPtReDIrPFqCnI6e\nnYzF8lbx24B91CoTk4rB4/NZOMI2KjyXo+EAe+yhDhMK2BKU15UVKqpXt2ur+VpY\nDBfoQuvZ91PT7f4sX53Y9lrJz6C3+xnI4K97o1GQh+2SAAgo72nZIdsCgYEAyzaH\n5rnVbSFFuYcAxUz3ClZH1shP2vnubnlFKTtV6NjvFGsswTVgeINCJhSxzTHX8VoJ\nAauOIxzr87T3RrH1BuN383ZQxlvEbHjbiBcnZrWklLXJEElRhLFcfgvtH01xSxuP\n/7WgLMsjnzJ/TE9tm96omf5iBygj5BSIOwclHyECgYEA36fCe6dAqfHcfzzVVatb\nEYqT/I0M/A9sdAUmTWkFh/FtgAuPdV3J75YvJgDwh0yT58MIw9BphsqEPWRm9tYM\nkLTeN3ThnPTq9VGSHiKIXC78mo7rmBy3YGiQ2M3Zvyq9vOPxhQhYSwRexFXOhUt0\nX2SYVCOE2MeGIAXt8jS3IZUCgYBO/cR4AHag9BUJWBwJlbBVuVI1gCniYdK36LXk\noCb12xWcJ0j/VYNJdSRKbzLqI1zgeXIUzx3yMjTZx9dzCIvJgLRI1A3z/QnubFBR\np0Zum179W2hrx0RDwznD2Vj0GQNYAb/I004O+2u+Xz+yZxGhTDzXl1V9mLHS39RQ\ntadNYQKBgQC+R83Yc4DFHluXa+k7jOIi5Zm9FwlLJZnIV9uZtAgMlO/o7BFBTQWx\nFgQBWR50cPxgzX9Jm8FvRUypAM4kvQtIM56+yVCxyk3J8Djv/VsF27a1Qer9s7TM\nhyqFfoWmTRQfYvWOsLxs4vcZABBaiidwTEMkod5rkoTHEgyDxAVJUA==\n-----END RSA PRIVATE KEY-----\n".freeze

    context 'when Yoti receives a string as a pem key' do
      before do
        Yoti.configuration.key = SECRET_KEY
      end

      it 'returns the secret key as a string' do
        expect(Yoti::SSL.pem).to eql(SECRET_KEY)
      end
    end

    context 'when Yoti receives a file as a pem key' do
      before do
        Yoti.configuration.key_file_path = 'spec/fixtures/ruby-sdk-test.pem'
      end

      it 'returns the secret key as a string' do
        expect(Yoti::SSL.pem).to eql(SECRET_KEY)
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
      expected_key = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs9zAY5K9O92zfmRhxBO0NX8Dg7UyyIaLE5GdbCMimlccew2p8LN6P8EDUoU7hiCbW1EQ/cp4iZVIp7UPA3AO/ecuejs2DjkFQOeMGnSlwD0pk74ZI3ammQtYm2ml47IWGrciMh4dPIPh0SOF+tVD0kHhAB9cMaj96Ij2De60Y7SeqvIXUHCtnoHId7Zk5I71mtewAnb9Gpx+wPnr2gpX/uUqkh+3ZHsF2eNCpw/ICvKj4UkNXopUyBemDp3n/s7u8TFyewp7ipPbFxDmxZKJT9SjZNFFe/jc2V/R2uC9qSFRKpTsxqmXggjiBlH46cpyg2SeYFj1p5bkpKZ10b3iOwIDAQAB'
      expect(key_from_pem).to eql(expected_key)
    end
  end

  describe '.get_secure_signature' do
    it 'generates secure random token' do
      token = Yoti::SSL.get_secure_signature('message')
      expect(token.length).to eql(344)
    end
  end

  describe '.decipher' do
    text = 'cipher text'
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    let(:key) { cipher.random_key }
    let(:iv) { cipher.random_iv }
    let(:ciphered_text) { cipher.update(text) + cipher.final }

    it 'decrypts the ciphered text using the key and iv' do
      expect(Yoti::SSL.decipher(key, iv, ciphered_text)).to eql('cipher text')
    end
  end
end
