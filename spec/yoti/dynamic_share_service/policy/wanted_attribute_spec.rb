# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::WantedAttribute' do
  describe '.to_json' do
    let(:attribute) do
      Yoti::DynamicSharingService::WantedAttribute
        .builder
        .with_name('TEST NAME')
        .build
    end
    it 'marshals the attribute' do
      expected = '{"name":"TEST NAME"}'
      expect(attribute.to_json).to eql expected
    end
  end

  describe '.builder' do
    describe '.with_name' do
      let(:attribute) do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name('TEST VALUE')
          .build
      end
      it 'sets the name' do
        expect(attribute.name).to eql 'TEST VALUE'
      end
    end

    describe '.with_derivation' do
      let(:attribute) do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name('Test')
          .with_derivation('TEST VALUE')
          .build
      end
      it 'sets a derivation' do
        expect(attribute.derivation).to eql 'TEST VALUE'
      end
    end

    describe '.with_constraint' do
      let :constraint do
        Yoti::DynamicSharingService::SourceConstraint
          .builder
          .with_passport
          .build
      end
      let :attribute do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name('Test')
          .with_constraint(constraint)
          .build
      end

      it 'has a source constraint' do
        expect(attribute.constraints.length).to eql 1
      end

      it 'marshals to json' do
        expect(attribute.to_json).to eql '{"name":"Test","constraints":[{"type":"SOURCE","preferred_sources":{"anchors":[{"name":"PASSPORT"}]}}]}'
      end
    end

    describe '.with_accept_self_asserted' do
      let(:attribute) do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name('Test')
          .with_accept_self_asserted
          .build
      end
      it 'contains self asserted in the json dump' do
        expect(attribute.to_json).to eql '{"name":"Test","accept_self_asserted":true}'
      end
      it 'accepts self asserted' do
        expect(attribute.accept_self_asserted).to eql true
      end
    end

    describe 'without .with_accept_self_asserted' do
      let :attribute do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_name('Test')
          .build
      end
      it 'doesn\'t add self asserted to the payload' do
        expect(attribute.accept_self_asserted).to eql false
      end
      it 'doesn\'t contain self asserted in the json dump' do
        expect(attribute.to_json).to eql '{"name":"Test"}'
      end
    end
  end
end
