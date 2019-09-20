# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    # A Location Constraint
    class LocationConstraintExtension
      EXTENSION_TYPE = 'LOCATION_CONSTRAINT'

      attr_reader :content
      attr_reader :type

      def initialize
        @content = {
          expected_device_location: {
            latitude: nil,
            longitude: nil,
            radius: nil,
            uncertainty: nil
          }
        }
        @type = EXTENSION_TYPE
      end

      def self.builder
        LocationConstraintExtensionBuilder.new
      end
    end

    # Builder for LocationConstraintExtension
    class LocationConstraintExtensionBuilder
      def with_latitude(latitude)
        @latitude = latitude
        self
      end

      def with_longitude(longitude)
        @longitude = longitude
        self
      end

      def with_radius(radius)
        @radius = radius
        self
      end

      def with_uncertainty(uncertainty)
        @uncertainty = uncertainty
        self
      end

      def build
        extension = LocationConstraintExtension.new
        extension.instance_variable_get(:@content)[:expected_device_location] = {
          latitude: @latitude,
          longitude: @longitude,
          radius: @radius,
          uncertainty: @uncertainty
        }
        extension
      end
    end
  end
end
