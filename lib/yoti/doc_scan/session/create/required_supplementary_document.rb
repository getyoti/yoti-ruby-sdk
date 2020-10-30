# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class RequiredSupplementaryDocument < RequiredDocument
          #
          # @param [Objective] objective
          # @param [Array<String>] document_types
          # @param [Array<String>] country_codes
          #
          def initialize(objective, document_types, country_codes)
            super(Constants::SUPPLEMENTARY_DOCUMENT)

            Validation.assert_is_a(Objective, objective, 'objective')
            @objective = objective

            Validation.assert_is_a(Array, document_types, 'document_types', true)
            @document_types = document_types

            Validation.assert_is_a(Array, country_codes, 'country_codes', true)
            @country_codes = country_codes
          end

          def as_json(*_args)
            json = super
            json[:objective] = @objective.as_json
            json[:document_types] = @document_types unless @document_types.nil?
            json[:country_codes] = @country_codes unless @country_codes.nil?
            json
          end

          #
          # @return [RequiredSupplementaryDocumentBuilder]
          #
          def self.builder
            RequiredSupplementaryDocumentBuilder.new
          end
        end

        class RequiredSupplementaryDocumentBuilder
          #
          # @param [Objective] objective
          #
          # @return [self]
          #
          def with_objective(objective)
            Validation.assert_is_a(Objective, objective, 'objective')
            @objective = objective
            self
          end

          #
          # @param [Array<String>] country_codes
          #
          # @return [self]
          #
          def with_country_codes(country_codes)
            Validation.assert_is_a(Array, country_codes, 'country_codes')
            @country_codes = country_codes
            self
          end

          #
          # @param [Array<String>] document_types
          #
          # @return [self]
          #
          def with_document_types(document_types)
            Validation.assert_is_a(Array, document_types, 'document_types')
            @document_types = document_types
            self
          end

          #
          # @return [RequiredSupplementaryDocument]
          #
          def build
            RequiredSupplementaryDocument.new(
              @objective,
              @document_types,
              @country_codes
            )
          end
        end
      end
    end
  end
end
