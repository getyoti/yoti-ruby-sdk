# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::ThirdPartyAttributeDefinition' do
  describe '#to_json' do
    let :name do
      'AttributeName'
    end
    let :defn do
      Yoti::DynamicSharingService::ThirdPartyAttributeDefinition.new(name)
    end
    it 'marshals into json' do
      expected = '{"name":"AttributeName"}'
      expect(defn.to_json).to eql expected
    end
  end
end

describe 'Yoti::DynamicSharingService::ThirdPartyAttributeExtension' do
  describe '#to_json' do
    let :expiry_date do
      DateTime.new(2006, 4, 3, 2, 30, 50)
    end

    let :attr_name do
      'AttributeName'
    end

    let :ext do
      Yoti::DynamicSharingService::ThirdPartyAttributeExtension
        .builder
        .with_expiry_date(expiry_date)
        .with_definitions(attr_name)
        .build
    end

    it 'marshals into json' do
      expected = '{"type":"THIRD_PARTY_ATTRIBUTE","content":{"expiry_date":"2006-04-03T02:30:50.000Z","definitions":[{"name":"AttributeName"}]}}'
      expect(ext.to_json).to eql expected
    end
  end
end

describe 'Yoti::DynamicSharingService::ThirdPartyAttributeExtensionContent' do
  let :attr_name do
    'AttributeName'
  end

  describe '#to_json' do
    [
      ['2006-04-03T02:30:50.000Z', '2006-04-03T02:30:50.000Z'],
      ['2006-04-03T02:30:50.000+00:00', '2006-04-03T02:30:50.000Z'],
      ['2006-04-03T02:30:50.000+02:00', '2006-04-03T00:30:50.000Z'],
      ['2006-04-03T02:30:50.000-02:00', '2006-04-03T04:30:50.000Z']
    ].each do |input_date, output_date|
      it "Formats expiry date #{input_date} as UTC" do
        content = Yoti::DynamicSharingService::ThirdPartyAttributeExtensionContent.new(
          DateTime.parse(input_date),
          [Yoti::DynamicSharingService::ThirdPartyAttributeDefinition.new(attr_name)]
        )

        expected = {
          expiry_date: output_date,
          definitions: [
            { name: attr_name }
          ]
        }.to_json

        expect(content.to_json).to eql expected
      end
    end

    it 'Formats expiry date Time object as UTC' do
      content = Yoti::DynamicSharingService::ThirdPartyAttributeExtensionContent.new(
        Time.new(2006, 4, 3, 2, 30, 50, '+00:00'),
        [Yoti::DynamicSharingService::ThirdPartyAttributeDefinition.new(attr_name)]
      )

      expected = {
        expiry_date: '2006-04-03T02:30:50.000Z',
        definitions: [
          { name: attr_name }
        ]
      }.to_json

      expect(content.to_json).to eql expected
    end
  end
end
