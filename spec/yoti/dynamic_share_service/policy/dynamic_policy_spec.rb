# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::Policy' do
  let :attribute_name do
    'ATTRIBUTE_NAME'
  end
  describe '.to_json' do
    let(:policy) do
      Yoti::DynamicSharingService::Policy
        .builder
        .with_full_name
        .with_age_over 18
        .with_pin_auth
        .build
    end
    it 'marshals the policy' do
      expected = '{"wanted":[{"name":"full_name"},{"name":"date_of_birth","derivation":"age_over:18"}],"wanted_auth_types":[2]}'
      expect(policy.to_json).to eql expected
    end
  end

  describe '.builder' do
    describe '.with_wanted_attribute' do
      let :attribute do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name attribute_name
          .build
      end
      let :policy do
        Yoti::DynamicSharingService::Policy
          .builder
          .with_wanted_attribute attribute
          .build
      end
      it 'adds an attribute' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql attribute_name
      end
    end

    describe '.with_wanted_attribute_by_name' do
      let :policy do
        Yoti::DynamicSharingService::Policy
          .builder
          .with_wanted_attribute_by_name attribute_name
          .build
      end
      it 'adds an attribute' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql attribute_name
      end
    end

    describe '.with_family_name' do
      let :policy do
        Yoti::DynamicSharingService::Policy
          .builder
          .with_family_name
          .build
      end
      it 'requests family name' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::FAMILY_NAME
      end
    end

    describe '.with_given_names' do
      let :policy do
        Yoti::DynamicSharingService::Policy
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
        Yoti::DynamicSharingService::Policy
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
        Yoti::DynamicSharingService::Policy
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
        Yoti::DynamicSharingService::Policy
          .builder
          .with_wanted_attribute(
            Yoti::DynamicSharingService::WantedAttribute
              .builder
              .with_name(Yoti::Attribute::DATE_OF_BIRTH)
              .with_derivation('age_over:18')
              .build
          )
          .build
      end
      it 'requests an age verification' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql 'age_over:18'
      end
    end

    describe '.with_age_over' do
      let :policy do
        Yoti::DynamicSharingService::Policy
          .builder
          .with_age_over 21
          .build
      end
      it 'requests an age over 21' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql 'age_over:21'
      end
    end

    describe '.with_age_under' do
      let :policy do
        Yoti::DynamicSharingService::Policy
          .builder
          .with_age_under 16
          .build
      end
      it 'requests an age under 16' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::DATE_OF_BIRTH
        expect(policy.wanted.first.derivation).to eql 'age_under:16'
      end
    end

    describe '.with_gender' do
      let :policy do
        Yoti::DynamicSharingService::Policy
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
        Yoti::DynamicSharingService::Policy
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
        Yoti::DynamicSharingService::Policy
          .builder
          .with_structured_postal_address
          .build
      end
      it 'requests a structured postal address' do
        expect(policy.wanted.length).to eql 1
        expect(policy.wanted.first.name).to eql Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS
      end
    end

  end
end



