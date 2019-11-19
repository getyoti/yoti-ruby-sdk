# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::SourceConstraint' do
  describe '.to_json' do
    let(:source_constraint) do
      Yoti::DynamicSharingService::SourceConstraint
        .builder
        .with_passport
        .build
    end
    it 'marshals the source constraint' do
      expected = '{"type":"SOURCE","preferred_sources":{"anchors":[{"name":"PASSPORT"}]}}'
      expect(source_constraint.to_json).to eql expected
    end
  end

  describe '.builder' do
    let :value do
      'TEST VALUE'
    end
    let :builder do
      Yoti::DynamicSharingService::SourceConstraint.builder
    end

    describe '.with_anchor_by_value' do
      let :constraint do
        builder.with_anchor_by_value(value, '').build
      end

      it 'adds an anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value).to eql value
      end
    end
    describe '.with_anchor' do
      let :anchor do
        Yoti::DynamicSharingService::WantedAnchor.builder.with_value(value).build
      end
      let :constraint do
        builder.with_anchor(anchor).build
      end

      it 'adds an anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value).to eql value
      end
    end

    describe '.with_passport' do
      let :constraint do
        builder.with_passport('').build
      end

      it 'adds a passport anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value)
          .to eql(Yoti::DynamicSharingService::SourceConstraint::PASSPORT)
      end
    end

    describe '.with_driving_licence' do
      let :constraint do
        builder.with_driving_licence('').build
      end

      it 'adds a driving licence anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value)
          .to eql(Yoti::DynamicSharingService::SourceConstraint::DRIVING_LICENCE)
      end
    end

    describe '.with_national_id' do
      let :constraint do
        builder.with_national_id('').build
      end

      it 'adds a national id anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value)
          .to eql(Yoti::DynamicSharingService::SourceConstraint::NATIONAL_ID)
      end
    end

    describe '.with_passcard' do
      let :constraint do
        builder.with_passcard('').build
      end

      it 'adds a passcard anchor' do
        expect(constraint.anchors.length).to eql 1
        expect(constraint.anchors.first.value)
          .to eql(Yoti::DynamicSharingService::SourceConstraint::PASS_CARD)
      end
    end

    describe '.with_soft_preference' do
      context 'set true' do
        let :constraint do
          builder.with_soft_preference.build
        end

        it 'has soft preference set true' do
          expect(constraint.soft_preference).to be true
        end
      end

      context 'by default' do
        let :constraint do
          builder.build
        end

        it 'does not have soft preference set' do
          expect(constraint.soft_preference).to be false
        end
      end
    end
  end
end
