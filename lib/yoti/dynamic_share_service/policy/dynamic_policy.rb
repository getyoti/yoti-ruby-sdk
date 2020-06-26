# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # Describes a policy for a dynamic share
    class DynamicPolicy
      SELFIE_AUTH_TYPE = 1
      PIN_AUTH_TYPE = 2

      attr_reader :wanted_auth_types
      attr_reader :wanted

      def wanted_remember_me
        return true if @wanted_remember_me

        false
      end

      def to_json(*_args)
        as_json.to_json
      end

      def as_json(*_args)
        {
          wanted_auth_types: @wanted_auth_types,
          wanted: @wanted
        }
      end

      def self.builder
        DynamicPolicyBuilder.new
      end
    end

    # Builder for DynamicPolicy
    class DynamicPolicyBuilder
      def initialize
        @policy = DynamicPolicy.new
        @wanted_auth_types = {}
        @wanted_attributes = {}
      end

      def build
        @policy.instance_variable_set(
          :@wanted_auth_types,
          @wanted_auth_types
            .select { |_, wanted| wanted }
            .keys
        )
        @policy.instance_variable_set(:@wanted, @wanted_attributes.values)
        Marshal.load Marshal.dump @policy
      end

      #
      # @param [Bool] wanted
      #
      def with_wanted_remember_me(wanted = true)
        @policy.instance_variable_set(:@wanted_remember_me, wanted)
        self
      end

      #
      # @param [Integer] auth
      # @param [Bool] wanted
      #
      def with_wanted_auth_type(auth, wanted = true)
        @wanted_auth_types[auth] = wanted
        self
      end

      #
      # @param [Bool] wanted
      #
      def with_selfie_auth(wanted = true)
        with_wanted_auth_type(DynamicPolicy::SELFIE_AUTH_TYPE, wanted)
      end

      #
      # @param [Bool] wanted
      #
      def with_pin_auth(wanted = true)
        with_wanted_auth_type(DynamicPolicy::PIN_AUTH_TYPE, wanted)
      end

      #
      # @param [Yoti::DynamicSharingService::WantedAttribute] attribute
      #
      def with_wanted_attribute(attribute)
        key = attribute.derivation || attribute.name
        @wanted_attributes[key] = attribute
        self
      end

      #
      # @param [String] name
      # @param [Array<SourceConstraint>] constraints
      #
      def with_wanted_attribute_by_name(name, constraints: nil)
        attribute_builder = WantedAttribute.builder.with_name(name)
        constraints&.each do |constraint|
          attribute_builder.with_constraint constraint
        end
        attribute = attribute_builder.build
        with_wanted_attribute attribute
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_family_name(options = {})
        with_wanted_attribute_by_name Attribute::FAMILY_NAME, **options
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_given_names(options = {})
        with_wanted_attribute_by_name Attribute::GIVEN_NAMES, **options
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_full_name(options = {})
        with_wanted_attribute_by_name Attribute::FULL_NAME, **options
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_date_of_birth(options = {})
        with_wanted_attribute_by_name Attribute::DATE_OF_BIRTH, **options
      end

      #
      # @param [String] derivation
      # @param [Array<SourceConstraint>] constraints
      #
      def with_age_derived_attribute(derivation, constraints: nil)
        attribute_builder = WantedAttribute.builder
        attribute_builder.with_name(Attribute::DATE_OF_BIRTH)
        attribute_builder.with_derivation(derivation)
        constraints&.each do |constraint|
          attribute_builder.with_constraint constraint
        end
        with_wanted_attribute(attribute_builder.build)
      end

      #
      # @param [Integer] age
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_age_over(age, options = {})
        with_age_derived_attribute(Attribute::AGE_OVER + age.to_s, **options)
      end

      #
      # @param [Integer] age
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_age_under(age, options = {})
        with_age_derived_attribute(Attribute::AGE_UNDER + age.to_s, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_gender(options = {})
        with_wanted_attribute_by_name Attribute::GENDER, **options
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_postal_address(options = {})
        with_wanted_attribute_by_name(Attribute::POSTAL_ADDRESS, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_structured_postal_address(options = {})
        with_wanted_attribute_by_name(Attribute::STRUCTURED_POSTAL_ADDRESS, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_nationality(options = {})
        with_wanted_attribute_by_name(Attribute::NATIONALITY, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_phone_number(options = {})
        with_wanted_attribute_by_name(Attribute::PHONE_NUMBER, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_selfie(options = {})
        with_wanted_attribute_by_name(Attribute::SELFIE, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_email(options = {})
        with_wanted_attribute_by_name(Attribute::EMAIL_ADDRESS, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_document_details(options = {})
        with_wanted_attribute_by_name(Attribute::DOCUMENT_DETAILS, **options)
      end

      #
      # @option options [Array<SourceConstraint>] :constraints
      #
      def with_document_images(options = {})
        with_wanted_attribute_by_name(Attribute::DOCUMENT_IMAGES, **options)
      end
    end
  end
end
