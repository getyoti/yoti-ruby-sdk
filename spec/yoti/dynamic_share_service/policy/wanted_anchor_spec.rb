# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::WantedAnchor' do
  describe '.to_json' do
    let(:anchor) do
      Yoti::DynamicSharingService::WantedAnchor
        .builder
        .with_value('TEST NAME')
        .build
    end
    it 'marshals the attribute' do
      expected = '{"name":"TEST NAME","sub_type":null}'
      expect(anchor.to_json).to eql expected
    end
  end

  describe '.builder' do
    let :builder do
      Yoti::DynamicSharingService::WantedAnchor
        .builder
    end

    describe '.with_value' do
      let :name do
        'TEST VALUE'
      end
      let :anchor do
        builder.with_value(name).build
      end
      it 'sets value' do
        expect(anchor.value).to eql name
      end
    end

    describe '.with_sub_type' do
      let :sub_type do
        'TEST SUB TYPE'
      end
      let :anchor do
        builder.with_sub_type(sub_type).build
      end
      it 'sets the sub type' do
        expect(anchor.sub_type).to eql sub_type
      end
    end
  end
end
