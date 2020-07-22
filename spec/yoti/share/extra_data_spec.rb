# frozen_string_literal: true

require 'spec_helper'

require 'yoti'
require 'base64'

def create_extra_data_proto(*rows)
  extra_data = Yoti::Protobuf::Sharepubapi::ExtraData.new
  rows.each do |row|
    data = Yoti::Protobuf::Sharepubapi::DataEntry.new
    data.type = :THIRD_PARTY_ATTRIBUTE
    data.value = Yoti::Protobuf::Sharepubapi::ThirdPartyAttribute.encode(create_thirdparty_attribute_proto(*row))
    extra_data.list += [data]
  end
  extra_data
end

describe 'Yoti::Share::ExtraData' do
  let :token do
    'tokenValue1'
  end
  let :b64token do
    Base64.urlsafe_encode64(token, padding: false)
  end
  let :now do
    DateTime.now
  end
  context 'with empty ExtraData' do
    let :proto do
      Yoti::Protobuf::Sharepubapi::ExtraData.new
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.attribute_issuance_details' do
      it 'is none' do
        expect(extra_data.attribute_issuance_details).to be_nil
      end
    end
  end

  context 'with two third party attributes' do
    let :attribute_name do
      'attributeName1'
    end
    let :proto do
      create_extra_data_proto(
        [token, now, attribute_name],
        ['tokenValue2', now, 'attributeName2']
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.attribute_issuance_details' do
      it 'sets the token' do
        expect(extra_data.attribute_issuance_details.token).to eql b64token
      end
      it 'sets the expiry date' do
        expect(extra_data.attribute_issuance_details.expiry_date).to eql now
      end
      it 'sets the first' do
        expect(extra_data.attribute_issuance_details.attributes.length).to eql 1
        expect(extra_data.attribute_issuance_details.attributes[0].name).to eql attribute_name
      end
    end
  end

  context 'with multiple issuing attributes' do
    let :attribute1 do
      'attribute1'
    end
    let :attribute2 do
      'attribute2'
    end
    let :proto do
      create_extra_data_proto(
        [token, now, attribute1, attribute2]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.attribute_issuance_details' do
      it 'sets token value' do
        expect(extra_data.attribute_issuance_details.token).to eql b64token
      end
      it 'sets the expiry date' do
        expect(extra_data.attribute_issuance_details.expiry_date).to eql now
      end
      it 'sets two attributes' do
        expect(extra_data.attribute_issuance_details.attributes.length).to eql 2
        expect(extra_data.attribute_issuance_details.attributes[0].name).to eql attribute1
        expect(extra_data.attribute_issuance_details.attributes[1].name).to eql attribute2
      end
    end
  end

  context 'with no expiry date' do
    let :attribute do
      'attributeName'
    end
    let :proto do
      create_extra_data_proto(
        [token, nil, attribute]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.attribute_issuance_details' do
      it 'has the token value' do
        expect(extra_data.attribute_issuance_details.token).to eql b64token
      end
      it 'has a nil expiry date' do
        expect(extra_data.attribute_issuance_details.expiry_date).to eql nil
      end
      it 'has one attribute' do
        expect(extra_data.attribute_issuance_details.attributes.length).to eql 1
        expect(extra_data.attribute_issuance_details.attributes[0].name).to eql attribute
      end
    end
  end

  context 'with no issuing attributes' do
    let :proto do
      create_extra_data_proto(
        [token, now]
      )
    end
    let :extra_data do
      Yoti::Share::ExtraData.new(proto)
    end
    describe '.attribute_issuance_details' do
      it 'sets the token' do
        expect(extra_data.attribute_issuance_details.token).to eql b64token
      end
      it 'sets the expiry date' do
        expect(extra_data.attribute_issuance_details.expiry_date).to eql now
      end
      it 'has no attributes' do
        expect(extra_data.attribute_issuance_details.attributes.length).to eql 0
      end
    end
  end
end
