# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::Extension' do
  let :type do
    'TEST TYPE'
  end
  let :content do
    'TEST CONTENT'
  end
  let :extension do
    Yoti::DynamicSharingService::Extension
      .builder
      .with_type(type)
      .with_content(content)
      .build
  end

  describe '.to_json' do
    it 'marshals the scenario' do
      expected = '{"type":"TEST TYPE","content":"TEST CONTENT"}'
      expect(extension.to_json).to eql expected
    end
  end

  describe '.builder' do
    describe '.with_extension_type' do
      it 'sets the extension type' do
        expect(extension.type).to eql type
      end
    end

    describe '.with_content' do
      it 'sets the extension content' do
        expect(extension.content).to eql content
      end
    end
  end
end
