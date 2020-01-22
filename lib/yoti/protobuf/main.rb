$LOAD_PATH.unshift File.expand_path('./attrpubapi/', __dir__)

require 'google/protobuf'
require 'json'

require_relative 'attrpubapi/List_pb.rb'
require_relative 'compubapi/EncryptedData_pb.rb'
require_relative 'compubapi/SignedTimestamp_pb.rb'
require_relative 'sharepubapi/ExtraData_pb.rb'
require_relative 'sharepubapi/IssuingAttributes_pb.rb'
require_relative 'sharepubapi/ThirdPartyAttribute_pb.rb'

module Yoti
  module Protobuf
    class << self
      CT_UNDEFINED = :UNDEFINED # should not be seen, and is used as an error placeholder
      CT_STRING = :STRING # UTF-8 encoded text.
      CT_JPEG = :JPEG # standard .jpeg image.
      CT_DATE = :DATE # string in RFC3339 format (YYYY-MM-DD)
      CT_PNG = :PNG # standard .png image
      CT_JSON = :JSON # json_string
      CT_MULTI_VALUE = :MULTI_VALUE # multi value
      CT_INT = :INT # integer

      #
      # @deprecated replaced by user_profile
      #
      def current_user(receipt)
        return nil unless valid_receipt?(receipt)

        decode_profile(receipt['other_party_profile_content'])
      end

      def user_profile(receipt)
        return nil unless valid_receipt?(receipt)

        decipher_profile(receipt['other_party_profile_content'], receipt['wrapped_receipt_key'])
      end

      def application_profile(receipt)
        return nil unless valid_receipt?(receipt)

        decipher_profile(receipt['profile_content'], receipt['wrapped_receipt_key'])
      end

      def extra_data(receipt)
        return nil unless valid_receipt?(receipt)
        return nil if receipt['extra_data_content'].nil? || receipt['extra_data_content'] == ''

        decipher_extra_data(receipt['extra_data_content'], receipt['wrapped_receipt_key'])
      end

      def attribute_list(data)
        Yoti::Protobuf::Attrpubapi::AttributeList.decode(data)
      end

      def value_based_on_attribute_name(value, attr_name)
        case attr_name
        when Yoti::Attribute::DOCUMENT_DETAILS
          Yoti::DocumentDetails.new(value)
        when Yoti::Attribute::DOCUMENT_IMAGES
          raise(TypeError, 'Document Images could not be decoded') unless value.is_a?(Yoti::MultiValue)

          value.allow_type(Yoti::Image).items
        else
          value
        end
      end

      def value_based_on_content_type(value, content_type = nil)
        raise(TypeError, 'Warning: value is NULL') if value.empty? && content_type != CT_STRING

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
        when CT_MULTI_VALUE
          convert_multi_value(value)
        else
          Yoti::Log.logger.warn("Unknown Content Type '#{content_type}', parsing as a String")
          value.encode('utf-8')
        end
      end

      private

      def convert_multi_value(value)
        proto_multi_value = Yoti::Protobuf::Attrpubapi::MultiValue.decode(value)
        items = []
        proto_multi_value.values.each do |item|
          items.append value_based_on_content_type(item.data, item.content_type)
        end
        MultiValue.new(items)
      end

      def valid_receipt?(receipt)
        receipt.key?('other_party_profile_content') &&
          !receipt['other_party_profile_content'].nil? &&
          receipt['other_party_profile_content'] != ''
      end

      def decode_profile(profile_content)
        decoded_profile_content = Base64.decode64(profile_content)
        Yoti::Protobuf::Compubapi::EncryptedData.decode(decoded_profile_content)
      end

      def decipher_profile(profile_content, wrapped_key)
        decrypted_data = decipher_data(profile_content, wrapped_key)
        Protobuf.attribute_list(decrypted_data)
      end

      def decipher_extra_data(extra_data_content, wrapped_key)
        decrypted_data = decipher_data(extra_data_content, wrapped_key)
        proto = Yoti::Protobuf::Sharepubapi::ExtraData.decode(decrypted_data)
        Share::ExtraData.new(proto)
      end

      def decipher_data(encrypted_content, wrapped_key)
        encrypted_data = decode_profile(encrypted_content)
        unwrapped_key = Yoti::SSL.decrypt_token(wrapped_key)
        Yoti::SSL.decipher(unwrapped_key, encrypted_data.iv, encrypted_data.cipher_text)
      end
    end
  end
end
