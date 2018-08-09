require 'google/protobuf'
require 'json'
require_relative 'v3/attrpubapi/list_pb.rb'
require_relative 'v3/compubapi/encrypted_data_pb.rb'
require_relative 'v3/compubapi/signed_time_stamp_pb.rb'

module Yoti
  module Protobuf
    class << self
      CT_UNDEFINED = :UNDEFINED # should not be seen, and is used as an error placeholder
      CT_STRING = :STRING # UTF-8 encoded text.
      CT_JPEG = :JPEG # standard .jpeg image.
      CT_DATE = :DATE # string in RFC3339 format (YYYY-MM-DD)
      CT_PNG = :PNG # standard .png image
      CT_JSON = :JSON # json_string

      def current_user(receipt)
        return nil unless valid_receipt?(receipt)

        profile_content = receipt['other_party_profile_content']
        decoded_profile_content = Base64.decode64(profile_content)
        CompubapiV3::EncryptedData.decode(decoded_profile_content)
      end

      def attribute_list(data)
        AttrpubapiV3::AttributeList.decode(data)
      end

      def value_based_on_content_type(value, content_type = nil)
        case content_type
        when CT_UNDEFINED
          raise ProtobufError, 'The content type is invalid.'
        when CT_STRING, CT_DATE
          value.encode('utf-8')
        when CT_JSON
           JSON.parse(value)
        else
          value
        end
      end

      def image_uri_based_on_content_type(value, content_type = nil)
        case content_type
        when CT_JPEG
          'data:image/jpeg;base64,'.concat(Base64.strict_encode64(value))
        when CT_PNG
          'data:image/png;base64,'.concat(Base64.strict_encode64(value))
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
