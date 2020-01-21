# frozen_string_literal: true

require 'spec_helper'

require 'base64'
require 'yoti'

def create_thirdparty_attribute_proto(token, expiry_date, *definitions)
  issuing_attributes = Yoti::Protobuf::Sharepubapi::IssuingAttributes.new
  issuing_attributes.expiry_date = ''
  issuing_attributes.expiry_date = expiry_date.iso8601(9) if expiry_date
  definitions.each do |s|
    name = Yoti::Protobuf::Sharepubapi::Definition.new
    name.name = s
    issuing_attributes.definitions += [name]
  end

  attribute = Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute.new
  expect(attribute).to be_a(Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute)
  attribute.issuance_token = token
  attribute.issuing_attributes = issuing_attributes

  attribute
end

describe 'Yoti::Share::AttributeIssuanceDetails' do
  context 'with a valid thirdparty attribute' do
    let :token do
      'tokenValue'
    end
    let :b64token do
      Base64.strict_encode64 token
    end
    let :now do
      DateTime.now
    end
    let :attribute do
      'attributeName'
    end
    let :proto do
      proto = create_thirdparty_attribute_proto(token, now, attribute)
      expect(proto).to be_a(Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute)
      proto
    end
    let :attribute_issuance_details do
      Yoti::Share::AttributeIssuanceDetails.new(proto)
    end

    it 'sets the attribute name' do
      expect(attribute_issuance_details.attributes.length).to eql 1
      expect(attribute_issuance_details.attributes[0].name).to eql attribute
    end
    it 'sets the token value' do
      expect(attribute_issuance_details.token).to eql b64token
    end
    it 'sets the expiry date' do
      expect(attribute_issuance_details.expiry_date).to eql now
    end
  end

  context 'with an invalid date' do
    it 'sets a nil value for date' do
    end
  end

  context 'with any RFC3339 date' do
    [
      ['2006-01-02T22:04:05Z', DateTime.new(2006, 1, 2, 22, 4, 5)],
      ['2006-01-02T22:04:05.1Z', DateTime.new(2006, 1, 2, 22, 4, 5.1)],
      ['2006-01-02T22:04:05.12Z', DateTime.new(2006, 1, 2, 22, 4, 5.12)],
      ['2006-01-02T22:04:05.123Z', DateTime.new(2006, 1, 2, 22, 4, 5.123)],
      ['2006-01-02T22:04:05.1234Z', DateTime.new(2006, 1, 2, 22, 4, 5.1234)],
      ['2006-01-02T22:04:05.12345Z', DateTime.new(2006, 1, 2, 22, 4, 5.12345)],
      ['2006-01-02T22:04:05.123456Z', DateTime.new(2006, 1, 2, 22, 4, 5.123456)],
      ['2002-10-02T10:00:00-05:00', DateTime.new(2002, 10, 2, 15, 0, 0)],
      ['2002-10-02T10:00:00+11:00', DateTime.new(2002, 10, 1, 23, 0, 0)],
      ['1920-03-13T19:50:53.999999', DateTime.new(1920, 3, 13, 19, 50, 53.999999)],
      ['1920-03-13T19:50:54.000001', DateTime.new(1920, 3, 13, 19, 50, 54.000001)]
    ].each do |input, expected|
      it "Parses #{input} to #{expected}" do
        protostruct = Struct.new(:issuance_token, :issuing_attributes)
        attributestruct = Struct.new(:expiry_date, :definitions)
        proto = protostruct.new('', attributestruct.new(input, []))

        details = Yoti::Share::AttributeIssuanceDetails.new(proto)
        expect(details.expiry_date).to eql expected
      end
    end
  end
end
