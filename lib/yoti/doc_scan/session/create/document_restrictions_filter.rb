# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class DocumentRestrictionsFilter < DocumentFilter
          #
          # @param [String] inclusion
          # @param [Array<DocumentRestriction>] documents
          #
          def initialize(inclusion, documents)
            super(Constants::DOCUMENT_RESTRICTIONS)

            Validation.assert_is_a(String, inclusion, 'country_restriction')
            @inclusion = inclusion

            Validation.assert_is_a(Array, documents, 'documents')
            @documents = documents
          end

          def as_json(*_args)
            super.merge(
              inclusion: @inclusion,
              documents: @documents.map(&:as_json)
            ).compact
          end

          #
          # @return [DocumentRestrictionsFilterBuilder]
          #
          def self.builder
            DocumentRestrictionsFilterBuilder.new
          end
        end

        class DocumentRestrictionsFilterBuilder
          def initialize
            @documents = []
          end

          #
          # @return [self]
          #
          def for_inclusion
            @inclusion = Constants::INCLUDE
            self
          end

          #
          # @return [self]
          #
          def for_exclusion
            @inclusion = Constants::EXCLUDE
            self
          end

          #
          # @param [DocumentRestriction] document_restriction
          #
          # @return [self]
          #
          def with_document_restriction(document_restriction)
            Validation.assert_is_a(DocumentRestriction, document_restriction, 'document_restriction')
            @documents.push(document_restriction)
            self
          end

          #
          # @return [DocumentRestrictionsFilter]
          #
          def build
            DocumentRestrictionsFilter.new(@inclusion, @documents)
          end
        end

        class DocumentRestriction
          #
          # @param [Array<String>] country_codes
          # @param [Array<String>] document_types
          #
          def initialize(country_codes, document_types)
            Validation.assert_is_a(Array, country_codes, 'country_codes', true)
            @country_codes = country_codes

            Validation.assert_is_a(Array, document_types, 'document_types', true)
            @document_types = document_types
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            json = {}
            json[:document_types] = @document_types unless @document_types.nil?
            json[:country_codes] = @country_codes unless @country_codes.nil?
            json
          end

          #
          # @return [DocumentRestrictionBuilder]
          #
          def self.builder
            DocumentRestrictionBuilder.new
          end
        end

        class DocumentRestrictionBuilder
          #
          # @param [Array<String>] document_types
          #
          # @return [self]
          #
          def with_document_types(document_types)
            @document_types = document_types
            self
          end

          #
          # @param [Array<String>] country_codes
          #
          # @return [self]
          #
          def with_countries(country_codes)
            @country_codes = country_codes
            self
          end

          #
          # @return [DocumentRestriction]
          #
          def build
            DocumentRestriction.new(@country_codes, @document_types)
          end
        end
      end
    end
  end
end
