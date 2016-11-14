require 'protobuf'
require_relative 'attribute_public_api/list.pb'
require_relative 'common_public_api/encrypted_data.pb'

module Yoti
  module Protobuf
    class << self
      CT_UNDEFINED = 0 # should not be seen, and is used as an error placeholder
      CT_STRING = 1 # UTF-8 encoded text.
      CT_JPEG = 2 # standard .jpeg image.
      CT_DATE = 3 # string in RFC3339 format (YYYY-MM-DD)
      CT_PNG = 4 # standard .png image

      def current_user(receipt)
        raise ProtobufError, 'The receipt has invalid data.' unless valid_recepit?(receipt)
        profile_content = receipt['other_party_profile_content']
        decoded_profile_content = Base64.decode64(profile_content)
        V1::Compubapi::EncryptedData.decode(decoded_profile_content)
      end

      def attribute_list(data)
        V1::Attrpubapi::AttributeList.decode(data)
      end

      def value_based_on_content_type(value, content_type = nil)
        case content_type
        when CT_UNDEFINED
          raise ProtobufError, 'The content type is invalid.'
        when CT_STRING
          value.encode('utf-8')
        when CT_JPEG
          'data:image/jpeg;base64,'.concat(Base64.strict_encode64(value))
        when CT_DATE
          value.encode('utf-8')
        when CT_PNG
          'data:image/png;base64,'.concat(Base64.strict_encode64(value))
        else
          value
        end
      end

      private

      def valid_recepit?(receipt)
        receipt.key?('other_party_profile_content') && !receipt['other_party_profile_content'].nil?
      end
    end
  end
end
