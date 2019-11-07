# frozen_string_literal: true

module Yoti
  module Share
    class ExtraData
      attr_reader :issuance_details

      #
      # Constructor
      #
      # @param [Yoti::Protobuf::Sharepubapi::ExtraData] proto
      #
      def initialize(proto)
        @issuance_details = nil

        proto.list.each do |data_entry|
          if data_entry.type == :THIRD_PARTY_ATTRIBUTE && @issuance_details.nil?
            attribute = Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute.decode(data_entry.value)
            @issuance_details = Yoti::Share::IssuanceDetails.new(attribute)
          end
        end
      end
    end
  end
end
