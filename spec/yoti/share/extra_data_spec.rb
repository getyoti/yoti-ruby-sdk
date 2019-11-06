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
  issuing_attributes.expiry_date = ""
  issuing_attributes.expiry_date = expiry_date.iso8601(9) if expiry_date != nil
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
  let :now do
    DateTime.now
  end
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
      it 'sets the token' do
        expect(extra_data.issuance_details.token).to eql token_value
      end
      it 'sets the expiry date' do
        expect(extra_data.issuance_details.expiry_date).to eql now
      end
      it 'sets the first' do
        expect(extra_data.issuance_details.attributes.length).to eql 1
        expect(extra_data.issuance_details.attributes[0].name).to eql attribute_name
      end
    end
  end

  context 'with multiple issuing attributes' do
    let :token_value do
      "tokenValue"
    end
    let :attribute1 do
      "attribute1"
    end
    let :attribute2 do
      "attribute2"
    end
    let :proto do
      create_extra_data_proto(
        [token_value, now, attribute1, attribute2]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.issuance_details' do
      it 'sets token value' do
        expect(extra_data.issuance_details.token).to eql token_value
      end
      it 'sets the expiry date' do
        expect(extra_data.issuance_details.expiry_date).to eql now
      end
      it 'sets two attributes' do
        expect(extra_data.issuance_details.attributes.length).to eql 2
        expect(extra_data.issuance_details.attributes[0].name).to eql attribute1
        expect(extra_data.issuance_details.attributes[1].name).to eql attribute2
      end
    end
  end

  context 'with no expiry date' do
    let :token do
      "tokenValue"
    end
    let :attribute do
      "attributeName"
    end
    let :proto do
      create_extra_data_proto(
        [token, nil, attribute]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.issuance_details' do
      it 'has the token value' do
        expect(extra_data.issuance_details.token).to eql token
      end
      it 'has a nil expiry date' do
        expect(extra_data.issuance_details.expiry_date).to eql nil
      end
      it 'has one attribute' do
        expect(extra_data.issuance_details.attributes.length).to eql 1
        expect(extra_data.issuance_details.attributes[0].name).to eql attribute
      end
    end
  end

  context 'with no issuing attributes' do
    let :token do
      "tokenValue"
    end
    let :attribute do
      "attributeName"
    end
    let :proto do
      create_extra_data_proto(
        [token, now]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.issuance_details' do
      it 'sets the token' do
        expect(extra_data.issuance_details.token).to eql token
      end
      it 'sets the expiry date' do
        expect(extra_data.issuance_details.expiry_date).to eql now
      end
      it 'has no attributes' do
        expect(extra_data.issuance_details.attributes.length).to eql 0
      end
    end
  end
end
