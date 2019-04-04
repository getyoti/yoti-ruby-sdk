$LOAD_PATH.unshift File.expand_path('./attrpubapi/', __dir__)

require 'google/protobuf'
require 'json'

require_relative 'attrpubapi/List_pb.rb'
require_relative 'compubapi/EncryptedData_pb.rb'
require_relative 'compubapi/SignedTimestamp_pb.rb'

module Yoti
  module Protobuf
    class << self
      CT_UNDEFINED = :UNDEFINED # should not be seen, and is used as an error placeholder
      CT_STRING = :STRING # UTF-8 encoded text.
      CT_JPEG = :JPEG # standard .jpeg image.
      CT_DATE = :DATE # string in RFC3339 format (YYYY-MM-DD)
      CT_PNG = :PNG # standard .png image
      CT_JSON = :JSON # json_string
      CT_INT = :INT # integer

      def current_user(receipt)
        return nil unless valid_receipt?(receipt)

        profile_content = receipt['other_party_profile_content']
        decoded_profile_content = Base64.decode64(profile_content)
        Yoti::Protobuf::Compubapi::EncryptedData.decode(decoded_profile_content)
      end

      def attribute_list(data)
        Yoti::Protobuf::Attrpubapi::AttributeList.decode(data)
      end

      def value_based_on_content_type(value, content_type = nil)
        case content_type
        when CT_STRING, CT_DATE
          value.encode('utf-8')
        when CT_JSON
          JSON.parse(value)
        when CT_INT
          value.to_i
        when CT_JPEG
          Yoti::ImageJpeg.new(value)
        when CT_PNG
          Yoti::ImagePng.new(value)
        else
          Yoti::Log.logger.warn("Unknown Content Type '#{content_type}', parsing as a String")
          value.encode('utf-8')
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
