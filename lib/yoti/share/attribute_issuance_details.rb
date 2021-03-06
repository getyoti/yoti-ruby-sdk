# frozen_string_literal: true

require 'base64'

module Yoti
  module Share
    class Definition
      # @return [String]
      attr_reader :name

      #
      # Constructor
      #
      # @param [String] name
      #
      def initialize(name)
        @name = name
      end
    end

    class AttributeIssuanceDetails
      # @return [String]
      attr_reader :token

      # @return [Array<Yoti::Share::Definition>]
      attr_reader :attributes

      # @return [DateTime|nil]
      attr_reader :expiry_date

      #
      # Constructor
      #
      # @param [Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute] data_entry
      #
      def initialize(data_entry)
        @token = Base64.strict_encode64(data_entry.issuance_token)
        begin
          @expiry_date = DateTime.parse(data_entry.issuing_attributes.expiry_date)
        rescue ArgumentError
          @expiry_date = nil
        end
        @attributes = data_entry.issuing_attributes.definitions.map do |defn|
          Definition.new(defn.name)
        end
      end
    end
  end
end
