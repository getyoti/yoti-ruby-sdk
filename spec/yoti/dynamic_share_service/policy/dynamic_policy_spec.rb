# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::DynamicPolicy' do
  let :attribute_name do
    'ATTRIBUTE_NAME'
  end
  describe '.to_json' do
    let(:policy) do
      Yoti::DynamicSharingService::DynamicPolicy
        .builder
        .with_full_name
        .with_age_over(18)
        .with_pin_auth
        .build
    end
    it 'marshals the policy' do
      expected = '{"wanted_auth_types":[2],"wanted":[{"name":"full_name"},{"name":"date_of_birth","derivation":"age_over:18"}]}'
      expect(policy.to_json).to eql expected
    end
  end

  describe '.builder' do
    describe '.with_wanted_attribute' do
      let :attribute do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name(attribute_name)
          .build
      end
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_wanted_attribute(attribute)
          .build
      end
      it 'adds an attribute' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql attribute_name
      end
    end

    describe '.with_wanted_attribute_by_name' do
      context 'minimal call' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_attribute_by_name(attribute_name)
            .build
        end
        it 'adds an attribute' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql attribute_name
          expect(policy.wanted.first.accept_self_asserted).to eql false
        end
      end

      context 'with a source constraint' do
        let :source_constraint do
          Yoti::DynamicSharingService::SourceConstraint
            .builder
            .build
        end
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_attribute_by_name(
              attribute_name,
              constraints: [source_constraint]
            )
            .build
        end

        it 'requests an attribute with a source constraint' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.constraints.length).to eql 1
          expect(policy.wanted.first.constraints.first.anchors).to eql []
        end
      end

      context 'with accept self asserted true' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_attribute_by_name(
              attribute_name,
              accept_self_asserted: true
            )
            .build
        end

        it 'requests an attribute with accept self asserted true' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.accept_self_asserted).to eql true
        end
      end

      context 'with accept self asserted false' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_attribute_by_name(
              attribute_name,
              accept_self_asserted: false
            )
            .build
        end

        it 'requests an attribute with accept self asserted false' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.accept_self_asserted).to eql false
        end
      end
    end

    describe '.with_family_name' do
      context 'with a source constraint' do
        let :source_constraint do
          Yoti::DynamicSharingService::SourceConstraint
            .builder
            .build
        end
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_family_name(constraints: [source_constraint])
            .build
        end
        it 'requests family name with a source constraint' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.constraints.length).to eql 1
          expect(policy.wanted.first.constraints.first.anchors).to eql []
        end
      end
      context 'without any options' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_family_name
            .build
        end
        it 'requests family name' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::FAMILY_NAME
          expect(policy.wanted.first.accept_self_asserted).to eql false
        end
      end
      context 'with accept self asserted' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_family_name(accept_self_asserted: true)
            .build
        end

        it 'requests an attribute with accept self asserted true' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.accept_self_asserted).to eql true
        end
      end
    end

    describe '.with_given_names' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_given_names
          .build
      end
      it 'requests given names' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::GIVEN_NAMES
      end
    end

    describe '.with_full_name' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_full_name
          .build
      end
      it 'requests full name' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::FULL_NAME
      end
    end

    describe '.with_date_of_birth' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_date_of_birth
          .build
      end
      it 'requests date of birth' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
      end
    end

    describe '.with_age_derived_attribute' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_age_derived_attribute('age_over:18')
          .build
      end
      it 'requests an age verification' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql(
          Yoti::Attribute::AGE_OVER + 18.to_s
        )
      end
    end

    describe '.with_age_over' do
      context 'with a source constraint' do
        let :source_constraint do
          Yoti::DynamicSharingService::SourceConstraint
            .builder
            .build
        end
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_age_over(21, constraints: [source_constraint])
            .build
        end
        it 'requests an age over 21 with a source constraint' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.constraints.length).to eql 1
          expect(policy.wanted.first.constraints.first.anchors).to eql []
        end
      end
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_age_over(21)
          .build
      end
      it 'requests an age over 21' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql(
          Yoti::Attribute::AGE_OVER + 21.to_s
        )
      end

      context 'without optional parameters' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_age_over(21)
            .build
        end
        it 'requests an age over 21' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
          expect(policy.wanted.first.derivation).to eql(
            Yoti::Attribute::AGE_OVER + 21.to_s
          )
        end
      end
    end

    describe '.with_age_under' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_age_under(16)
          .build
      end
      it 'requests an age under 16' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql(
          Yoti::Attribute::AGE_UNDER + 16.to_s
        )
      end
    end

    describe '.with_gender' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_gender
          .build
      end
      it 'requests a gender' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::GENDER
      end
    end

    describe '.with_postal_address' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_postal_address
          .build
      end
      it 'requests a postal address' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::POSTAL_ADDRESS
      end
    end

    describe '.with_structured_postal_address' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_structured_postal_address
          .build
      end
      it 'requests a structured postal address' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql(
          Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS
        )
      end
    end

    describe '.with_nationality' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_nationality
          .build
      end
      it 'requests a nationality' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::NATIONALITY
      end
    end

    describe '.with_phone_number' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_phone_number
          .build
      end
      it 'requests a phone number' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::PHONE_NUMBER
      end
    end

    describe '.with_selfie' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_selfie
          .build
      end
      it 'requests a selfie' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::SELFIE
      end
    end

    describe '.with_email' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_email
          .build
      end
      it 'requests an email' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::EMAIL_ADDRESS
      end
    end

    describe '.with_document_details' do
      context 'without a source constraint' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_document_details
            .build
        end

        it 'requests document details' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::DOCUMENT_DETAILS
        end
      end

      context 'with a source constraint' do
        let :source_constraint do
          Yoti::DynamicSharingService::SourceConstraint
            .builder
            .build
        end
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_document_details(constraints: [source_constraint])
            .build
        end

        it 'requests document details with a source constraint' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::DOCUMENT_DETAILS
          expect(policy.wanted.first.constraints.first)
            .to be_a(Yoti::DynamicSharingService::SourceConstraint)
        end
      end
    end

    describe '.with_document_images' do
      context 'without a source constraint' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_document_images
            .build
        end

        it 'requests document images' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::DOCUMENT_IMAGES
        end
      end

      context 'with a source constraint' do
        let :source_constraint do
          Yoti::DynamicSharingService::SourceConstraint
            .builder
            .build
        end
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_document_images(constraints: [source_constraint])
            .build
        end

        it 'requests document images with a source constraint' do
          expect(policy.wanted.length).to eql 1
          expect(policy.wanted.first.name).to eql Yoti::Attribute::DOCUMENT_IMAGES
          expect(policy.wanted.first.constraints.first)
            .to be_a(Yoti::DynamicSharingService::SourceConstraint)
        end
      end
    end

    describe '.with_wanted_auth_type' do
      context 'requesting PIN authorisation' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_auth_type(
              Yoti::DynamicSharingService::DynamicPolicy::PIN_AUTH_TYPE
            )
            .build
        end
        it 'requests PIN authorisation' do
          expect(policy.wanted_auth_types.length).to eql 1
          expect(policy.wanted_auth_types.first).to eql(
            Yoti::DynamicSharingService::DynamicPolicy::PIN_AUTH_TYPE
          )
        end
      end
      context 'unsetting PIN authorisation' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_auth_type(
              Yoti::DynamicSharingService::DynamicPolicy::PIN_AUTH_TYPE
            )
            .with_wanted_auth_type(
              Yoti::DynamicSharingService::DynamicPolicy::PIN_AUTH_TYPE,
              false
            )
            .build
        end
        it 'doesn\'t request PIN authorisation' do
          expect(policy.wanted_auth_types).to eql []
        end
      end
    end

    describe '.with_selfie_auth' do
      let :policy do
        Yoti::DynamicSharingService::DynamicPolicy
          .builder
          .with_selfie_auth
          .build
      end
      it 'requires Selfie authorisation' do
        expect(policy.wanted_auth_types.length).to eql 1
        expect(policy.wanted_auth_types.first).to eql(
          Yoti::DynamicSharingService::DynamicPolicy::SELFIE_AUTH_TYPE
        )
      end
    end

    describe '.with_wanted_remember_me' do
      context 'when called' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .with_wanted_remember_me
            .build
        end
        it 'requests a remember me id' do
          expect(policy.wanted_remember_me).to eql true
        end
      end
      context 'by default' do
        let :policy do
          Yoti::DynamicSharingService::DynamicPolicy
            .builder
            .build
        end
        it 'doesn\' request a remember me id' do
          expect(policy.wanted_remember_me).to eql false
        end
      end
    end
  end
end
