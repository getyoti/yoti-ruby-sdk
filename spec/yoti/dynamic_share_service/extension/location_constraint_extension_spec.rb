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
              expect { builder.with_latitude(num) }.to raise_error ArgumentError
            end
          end
        end
      end
    end

    describe '.with_longitude' do
      context 'with valid longitude' do
        [180, 90, 50, 3.0, -90, -180].each do |num|
          context num.to_s do
            let :ext do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
                .with_longitude(num)
                .build
            end
            it 'sets a longitude' do
              expect(ext.content[:expected_device_location][:longitude]).to eql num
            end
          end
        end
      end
      context 'with invalid longitude' do
        [181, 180.01, 190, -190, 'a string'].each do |num|
          context num.to_s do
            let :builder do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
            end
            it 'throws an exception' do
              expect { builder.with_longitude(num) }.to raise_error ArgumentError
            end
          end
        end
      end
    end

    describe '.with_radius' do
      context 'with valid radius' do
        [0, 3.0, 1e-3, 1e3].each do |num|
          context num.to_s do
            let :ext do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
                .with_radius(num)
                .build
            end
            it 'sets a radius' do
              expect(ext.content[:expected_device_location][:radius]).to eql num
            end
          end
        end
      end
      context 'with invalid radius' do
        [-1, -1e-6, -1e3, -2.5, 'a string'].each do |num|
          context num.to_s do
            let :builder do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
            end
            it 'throws an exception' do
              expect { builder.with_radius(num) }.to raise_error ArgumentError
            end
          end
        end
      end
    end

    describe '.uncertainty' do
      context 'with valid uncertainty' do
        [0, 3.0, 1e-3, 1e3].each do |num|
          context num.to_s do
            let :ext do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
                .with_uncertainty(num)
                .build
            end
            it 'sets an uncertainty' do
              expect(ext.content[:expected_device_location][:uncertainty]).to eql num
            end
          end
        end
      end
      context 'with invalid uncertainty' do
        [-1, -1e-6, -1e3, -2.5, 'a string'].each do |num|
          context num.to_s do
            let :builder do
              Yoti::DynamicSharingService::LocationConstraintExtension
                .builder
            end
            it 'throws an exception' do
              expect { builder.with_uncertainty(num) }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
