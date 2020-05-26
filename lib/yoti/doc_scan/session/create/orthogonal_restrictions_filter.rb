# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class OrthogonalRestrictionsFilter < DocumentFilter
          #
          # @param [CountryRestriction] country_restriction
          # @param [TypeRestriction] type_restriction
          #
          def initialize(country_restriction, type_restriction)
            super(Constants::ORTHOGONAL_RESTRICTIONS)

            Validation.assert_is_a(CountryRestriction, country_restriction, 'country_restriction', true)
            @country_restriction = country_restriction

            Validation.assert_is_a(TypeRestriction, type_restriction, 'type_restriction', true)
            @type_restriction = type_restriction
          end

          def as_json(*_args)
            json = super
            json[:country_restriction] = @country_restriction.as_json unless @country_restriction.nil?
            json[:type_restriction] = @type_restriction.as_json unless @type_restriction.nil?
            json
          end

          #
          # @return [OrthogonalRestrictionsFilterBuilder]
          #
          def self.builder
            OrthogonalRestrictionsFilterBuilder.new
          end
        end

        class OrthogonalRestrictionsFilterBuilder
          #
          # @param [Array<String>] country_codes
          #
          # @return [self]
          #
          def with_whitelisted_countries(country_codes)
            @country_restriction = CountryRestriction.new(
              Constants::INCLUSION_WHITELIST,
              country_codes
            )
            self
          end

          #
          # @param [Array<String>] country_codes
          #
          # @return [self]
          #
          def with_blacklisted_countries(country_codes)
            @country_restriction = CountryRestriction.new(
              Constants::INCLUSION_BLACKLIST,
              country_codes
            )
            self
          end

          #
          # @param [Array<String>] document_types
          #
          # @return [self]
          #
          def with_whitelisted_document_types(document_types)
            @type_restriction = TypeRestriction.new(
              Constants::INCLUSION_WHITELIST,
              document_types
            )
            self
          end

          #
          # @param [Array<String>] document_types
          #
          # @return [self]
          #
          def with_blacklisted_document_types(document_types)
            @type_restriction = TypeRestriction.new(
              Constants::INCLUSION_BLACKLIST,
              document_types
            )
            self
          end

          #
          # @return [OrthogonalRestrictionsFilter]
          #
          def build
            OrthogonalRestrictionsFilter.new(@country_restriction, @type_restriction)
          end
        end

        class CountryRestriction
          #
          # @param [String] inclusion
          # @param [Array<String>] country_codes
          #
          def initialize(inclusion, country_codes)
            Validation.assert_is_a(String, inclusion, 'inclusion')
            @inclusion = inclusion

            Validation.assert_is_a(Array, country_codes, 'country_codes')
            @country_codes = country_codes
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            {
              inclusion: @inclusion,
              country_codes: @country_codes
            }
          end
        end

        class TypeRestriction
          #
          # @param [String] inclusion
          # @param [Array<String>] document_types
          #
          def initialize(inclusion, document_types)
            Validation.assert_is_a(String, inclusion, 'inclusion')
            @inclusion = inclusion

            Validation.assert_is_a(Array, document_types, 'document_types')
            @document_types = document_types
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            {
              inclusion: @inclusion,
              document_types: @document_types
            }
          end
        end
      end
    end
  end
end
