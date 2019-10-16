# frozen_string_literal: true

require 'spec_helper'

describe 'Sandbox::Profile' do
  let :value do
    'value'
  end
  let :anchors do
    [Sandbox::Anchor.source('', timestamp: Time.utc(2007, 7, 6, 0, 0))]
  end
  describe '.with_given_names' do
    let :profile do
      Sandbox::Profile.new.with_given_names(value, anchors: anchors)
    end
    it 'sets a given name' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"given_names","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_full_name' do
    let :profile do
      Sandbox::Profile.new.with_full_name(value, anchors: anchors)
    end
    it 'sets a full name' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"full_name","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_family_name' do
    let :profile do
      Sandbox::Profile.new.with_family_name(value, anchors: anchors)
    end
    it 'sets a family name' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"family_name","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_date_of_birth' do
    let :profile do
      Sandbox::Profile.new.with_date_of_birth(Time.utc(2008, 7, 6, 0, 0), anchors: anchors)
    end
    it 'sets a date of birth' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"date_of_birth","value":"2008-07-06 00:00:00 UTC","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_age_verification' do
    let :profile do
      Sandbox::Profile.new.with_age_verification(
        dob: Time.utc(2008, 7, 6, 0, 0),
        derivation: Sandbox::Derivation.age_over(21),
        anchors: anchors
      )
    end
    it 'sets an age verification' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"date_of_birth","value":"2008-07-06 00:00:00 UTC","derivation":"age_over:21","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_gender' do
    let :profile do
      Sandbox::Profile.new.with_gender(value, anchors: anchors)
    end
    it 'sets a gender' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"gender","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_phone_number' do
    let :profile do
      Sandbox::Profile.new.with_phone_number(value, anchors: anchors)
    end
    it 'sets a phone number' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"phone_number","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_nationality' do
    let :profile do
      Sandbox::Profile.new.with_nationality(value, anchors: anchors)
    end
    it 'sets a nationality' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"nationality","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_postal_address' do
    let :profile do
      Sandbox::Profile.new.with_postal_address(value, anchors: anchors)
    end
    it 'sets a postal address' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"postal_address","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_structured_postal_address' do
    let :data do
      {
        FormattedAddress: 'Value'
      }
    end
    let :profile do
      Sandbox::Profile.new.with_structured_postal_address(data, anchors: anchors)
    end
    it 'sets a formatted address' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"structured_postal_address","value":"{\"FormattedAddress\":\"Value\"}","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_selfie' do
    let :data do
      [0xDE, 0xEA, 0xBE, 0xEF].pack('cccc')
    end
    let :profile do
      Sandbox::Profile.new.with_selfie(data, anchors: anchors)
    end
    it 'sets a selfie on the profile' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"selfie","value":"3uq+7w==","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_email_address' do
    let :profile do
      Sandbox::Profile.new.with_email_address(value, anchors: anchors)
    end
    it 'sets an email address' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"email_address","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_document_details' do
    let :profile do
      Sandbox::Profile.new.with_document_details(value, anchors: anchors)
    end
    it 'sets document details' do
      expected = '{"remember_me_id":"","profile_attributes":[{"name":"document_details","value":"value","derivation":"","optional":false,"anchors":[{"type":"SOURCE","value":"","sub_type":"","timestamp":1183680000}]}]}'
      expect(profile.to_json).to eql expected
    end
  end
  describe '.with_remember_me_id' do
    let :id do
      'REMEMBER ME'
    end
    let :profile do
      Sandbox::Profile.new.with_remember_me_id(id)
    end
    it 'sets the remember me id' do
      expected = '{"remember_me_id":"REMEMBER ME","profile_attributes":[]}'
      expect(profile.to_json).to eql expected
    end
  end
end
