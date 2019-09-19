# frozen_string_literal: true

require 'spec_helper'

require 'pry-byebug'

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
          .with_derivation('TEST VALUE')
          .build
      end
      it 'sets a derivation' do
        expect(attribute.derivation).to eql 'TEST VALUE'
      end
    end

    describe '.with_accept_self_asserted' do
      let(:attribute) do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .with_accept_self_asserted
          .build
      end
      it 'accepts self asserted' do
        expect(attribute.accept_self_asserted).to eql true
      end
    end
    describe 'without .with_accept_self_asserted' do
      let :attribute do
        Yoti::DynamicSharingService::WantedAttribute
          .builder
          .build
      end
      it 'doesn\'t accept self asserted by default' do
        expect(attribute.accept_self_asserted).to eql false
      end
    end
  end
end
