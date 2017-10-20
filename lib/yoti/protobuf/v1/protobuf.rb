require 'protobuf'
require_relative 'attribute_public_api/list.pb'
require_relative 'common_public_api/encrypted_data.pb'

module Yoti
  module Protobuf
    class << self
      CT_UNDEFINED = 0 # should not be seen, and is used as an error placeholder
      CT_STRING = 1 # UTF-8 encoded text.
      CT_DATE = 3 # string in RFC3339 format (YYYY-MM-DD)

      def current_user(receipt)
        return nil unless valid_receipt?(receipt)

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
        when CT_DATE
          value.encode('utf-8')
        else
          value
        end
      end

      private

      def valid_receipt?(receipt)
        receipt.key?('other_party_profile_content') &&
          !receipt['other_party_profile_content'].nil? &&
          receipt['other_party_profile_content'] != ''
      end
    end
  end
end
