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
      context 'with valid latitude' do
        [90, 50, 3.0, -90].each do |num|
          context num.to_s do
            let :ext do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
                .with_latitude(num)
                .build
            end
            it 'sets a latitude' do
              expect(ext.content[:expected_device_location][:latitude]).to eql num
            end
          end
        end
      end
      context 'with invalid latitude' do
        [91, 90.01, 150, -150, 'a string'].each do |num|
          context num.to_s do
            let :builder do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
            end
            it 'throws an exception' do
              expect { builder.with_latitude(num) }.to raise_error
            end
          end
        end
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
