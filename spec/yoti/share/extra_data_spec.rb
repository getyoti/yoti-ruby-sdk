# frozen_string_literal: true

require 'spec_helper'

require 'yoti'

def create_extra_data_proto(*rows)
  extra_data = Yoti::Protobuf::Sharepubapi::ExtraData.new()
  rows.each do |row|
    extra_data.list += [create_thirdparty_data_proto(*row)]
  end
  extra_data
end

def create_thirdparty_data_proto(token, expiry_date, *definitions)
  issuing_attributes = Yoti::Protobuf::Sharepubapi::IssuingAttributes.new()
  issuing_attributes.expiry_date = expiry_date.iso8601
  definitions.each do |s|
    name = Yoti::Protobuf::Sharepubapi::Definition.new()
    name.name = s
    issuing_attributes.definitions += [name]
  end

  attribute = Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute.new()
  attribute.issuance_token = token
  attribute.issuing_attributes = issuing_attributes

  row = Yoti::Protobuf::Sharepubapi::DataEntry.new()
  row.type = :THIRD_PARTY_ATTRIBUTE 
  row.value = Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute.encode(attribute)
  row
end

describe 'Yoti::Share::ExtraData' do
  context 'with empty ExtraData' do
    let :proto do
      Yoti::Protobuf::Sharepubapi::ExtraData.new()
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.issuance_details' do
      it 'is none' do
        expect(extra_data.issuance_details).to be_nil
      end
    end
  end

  context 'with two third party attributes' do
    let :token_value do
      "tokenValue1"
    end
    let :attribute_name do
      "attributeName1"
    end
    let :now do
      DateTime.now
    end
    let :proto do
      create_extra_data_proto(
        [token_value, now, attribute_name],
        ["tokenValue2", now, "attributeName2"],
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.issuance_details' do
      it 'sets the first' do
        expect(extra_data.issuance_details.attributes.length).to eql 1
        expect(extra_data.issuance_details.attributes[0].name).to eql attribute_name
      end
    end
  end

  context 'with multiple issuing attributes' do
    describe '.issuance_details' do
      it 'sets both attributes' do
      end
    end
  end

  context 'with no expiry date' do
    describe '.issuance_details' do
      it 'has a nil expiry date' do
      end
      it 'has one attribute' do
      end
    end
  end

  context 'with no issuing attributes' do
    describe '.issuance_details' do
      it 'sets the token' do
      end
      it 'has no attributes' do
      end
    end
  end
end
