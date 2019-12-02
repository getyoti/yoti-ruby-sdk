# frozen_string_literal: true

require 'base64'

module Yoti
  module Share
    class AttributeIssuanceDetails
      attr_reader :token
      attr_reader :attributes
      attr_reader :expiry_date

      #
      # Constructor
      #
      # @param [Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute] data_entry
      #
      def initialize(data_entry)
        @token = Base64.encode64(data_entry.issuance_token)
        begin
          @expiry_date = DateTime.parse(data_entry.issuing_attributes.expiry_date)
        rescue ArgumentError
          @expiry_date = nil
        end
        @attributes = data_entry.issuing_attributes.definitions
      end
    end
  end
end
