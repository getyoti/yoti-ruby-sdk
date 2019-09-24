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

      def to_json(*args)
        as_json.to_json(*args)
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

      def with_wanted_remember_me(wanted = true)
        @policy.instance_variable_set(:@wanted_remember_me, wanted)
        self
      end

      def with_wanted_auth_type(auth, wanted = true)
        @wanted_auth_types[auth] = wanted
        self
      end

      def with_selfie_auth(wanted = true)
        with_wanted_auth_type(DynamicPolicy::SELFIE_AUTH_TYPE, wanted)
      end

      def with_pin_auth(wanted = true)
        with_wanted_auth_type(DynamicPolicy::PIN_AUTH_TYPE, wanted)
      end

      def with_wanted_attribute(attribute)
        key = attribute.derivation || attribute.name
        @wanted_attributes[key] = attribute
        self
      end

      def with_wanted_attribute_by_name(name)
        attribute = WantedAttribute.builder.with_name(name).build
        with_wanted_attribute attribute
      end

      def with_family_name
        with_wanted_attribute_by_name Attribute::FAMILY_NAME
      end

      def with_given_names
        with_wanted_attribute_by_name Attribute::GIVEN_NAMES
      end

      def with_full_name
        with_wanted_attribute_by_name Attribute::FULL_NAME
      end

      def with_date_of_birth
        with_wanted_attribute_by_name Attribute::DATE_OF_BIRTH
      end

      def with_age_derived_attribute(derivation)
        with_wanted_attribute(
          WantedAttribute
          .builder
          .with_name(Attribute::DATE_OF_BIRTH)
          .with_derivation(derivation)
          .build
        )
      end

      def with_age_over(age)
        with_age_derived_attribute(Attribute::AGE_OVER + age.to_s)
      end

      def with_age_under(age)
        with_age_derived_attribute(Attribute::AGE_UNDER + age.to_s)
      end

      def with_gender
        with_wanted_attribute_by_name Attribute::GENDER
      end

      def with_postal_address
        with_wanted_attribute_by_name(Attribute::POSTAL_ADDRESS)
      end

      def with_structured_postal_address
        with_wanted_attribute_by_name(Attribute::STRUCTURED_POSTAL_ADDRESS)
      end

      def with_nationality
        with_wanted_attribute_by_name(Attribute::NATIONALITY)
      end

      def with_phone_number
        with_wanted_attribute_by_name(Attribute::PHONE_NUMBER)
      end

      def with_selfie
        with_wanted_attribute_by_name(Attribute::SELFIE)
      end

      def with_email
        with_wanted_attribute_by_name(Attribute::EMAIL_ADDRESS)
      end
    end
  end
end
