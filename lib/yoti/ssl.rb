require 'openssl'
require 'base64'

module Yoti
  # Manages security behaviour that requires the use of OpenSSL actions
  module SSL
    class << self
      # Gets the private key from either a String (YOTI_KEY)
      # or a pem file (YOTI_KEY_FILE_PATH)
      # @return [String] the content of the private key
      def pem
        @pem ||= begin
          if Yoti.configuration.key.to_s.empty?
            File.read(Yoti.configuration.key_file_path, encoding: 'utf-8')
          else
            Yoti.configuration.key
          end
        end
      end

      # Uses the pem key to decrypt an encrypted connect token
      # @param encrypted_connect_token [String]
      # @return [String] decrypted connect token decoded in base 64
      def decrypt_token(encrypted_connect_token)
        raise SslError, 'Encrypted token cannot be nil.' unless encrypted_connect_token

        begin
          private_key.private_decrypt(Base64.urlsafe_decode64(encrypted_connect_token))
        rescue StandardError => error
          raise SslError, "Could not decrypt token. #{error}"
        end
      end

      # Extracts the public key from pem key, converts it to a DER base 64 encoded value
      # @return [String] base 64 encoded anthentication key
      def auth_key_from_pem
        public_key = private_key.public_key
        Base64.strict_encode64(public_key.to_der)
      end

      # Sign message using a secure SHA256 hash and the private key
      # @param message [String] message to be signed
      # @return [String] signed message encoded in base 64
      def get_secure_signature(message)
        digest = OpenSSL::Digest::SHA256.new
        Base64.strict_encode64(private_key.sign(digest, message))
      end

      # Uses the decrypted receipt key and the current user's iv to decode the text
      # @param key [String] base 64 decoded key
      # @param iv [String] base 64 decoded iv
      # @param text [String] base 64 decoded cyphered text
      # @return [String] base 64 decoded deciphered text
      def decipher(key, iv, text)
        ssl_decipher = OpenSSL::Cipher.new('AES-256-CBC')
        ssl_decipher.decrypt
        ssl_decipher.key = key
        ssl_decipher.iv = iv
        ssl_decipher.update(text) + ssl_decipher.final
      end

      private

      def private_key
        @private_key ||= OpenSSL::PKey::RSA.new(pem)
      rescue StandardError => error
        raise SslError, "The secure key is invalid. #{error}"
      end
    end
  end
end
