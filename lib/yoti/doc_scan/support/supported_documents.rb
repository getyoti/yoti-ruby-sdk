# frozen_string_literal: true

module Yoti
  module DocScan
    module Support
      class SupportedDocumentsResponse
        # @return [Array<SupportedCountry>]
        attr_reader :supported_countries

        #
        # @param [Hash] response
        #
        def initialize(response)
          if response['supported_countries'].nil?
            @supported_countries = []
          else
            Validation.assert_is_a(Array, response['supported_countries'], 'supported_countries')
            @supported_countries = response['supported_countries'].map { |country| SupportedCountry.new(country) }
          end
        end
      end

      class SupportedCountry
        # @return [String]
        attr_reader :code

        # @return [Array<SupportedDocument>]
        attr_reader :supported_documents

        #
        # @param [Hash] country
        #
        def initialize(country)
          Validation.assert_is_a(String, country['code'], 'code', true)
          @code = country['code']

          if country['supported_documents'].nil?
            @supported_documents = []
          else
            Validation.assert_is_a(Array, country['supported_documents'], 'supported_documents')
            @supported_documents = country['supported_documents'].map { |document| SupportedDocument.new(document) }
          end
        end
      end

      class SupportedDocument
        # @return [String]
        attr_reader :type

        #
        # @param [Hash] document
        #
        def initialize(document)
          Validation.assert_is_a(String, document['type'], 'type', true)
          @type = document['type']
        end
      end
    end
  end
end
