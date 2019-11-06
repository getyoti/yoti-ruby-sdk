# frozen_string_literal: true

module Yoti
  module Share

    attr_reader :token
    attr_reader :attributes
    attr_reader :expiry_date

    class IssuanceDetails

      attr_reader :token
      attr_reader :attributes
      attr_reader :expiry_date

      def initialize data_entry
        @token = data_entry.issuance_token
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

