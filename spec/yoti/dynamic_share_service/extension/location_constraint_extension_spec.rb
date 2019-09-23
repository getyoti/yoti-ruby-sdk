# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::LocationConstraintExtension' do
  describe '.type' do
    let :ext do
      Yoti::DynamicSharingService::LocationConstraintExtension
        .builder
        .build
    end
    it 'has the location constraint extension type' do
      expect(ext.type).to eql Yoti::DynamicSharingService::LocationConstraintExtension::EXTENSION_TYPE
    end
  end

  describe '.builder' do
    describe '.with_latitude' do
      let :ext do
        Yoti::DynamicSharingService::LocationConstraintExtension
          .builder
          .with_latitude(50)
          .build
      end
      it 'sets a latitude' do
        expect(ext.content[:expected_device_location][:latitude]).to eql 50
      end
    end

    describe '.with_longitude' do
      let :ext do
        Yoti::DynamicSharingService::LocationConstraintExtension
          .builder
          .with_longitude(75)
          .build
      end
      it 'sets a longitude' do
        expect(ext.content[:expected_device_location][:longitude]).to eql 75
      end
    end

    describe '.with_radius' do
      let :ext do
        Yoti::DynamicSharingService::LocationConstraintExtension
          .builder
          .with_radius(60)
          .build
      end
      it 'sets a radius' do
        expect(ext.content[:expected_device_location][:radius]).to eql 60
      end
    end

    describe '.uncertainty' do
      let :ext do
        Yoti::DynamicSharingService::LocationConstraintExtension
          .builder
          .with_uncertainty(30)
          .build
      end
      it 'sets an uncertainty' do
        expect(ext.content[:expected_device_location][:uncertainty]).to eql 30
      end
    end
  end
end
