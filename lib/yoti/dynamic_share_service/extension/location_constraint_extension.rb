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
        unless latitude.is_a?(Integer) || latitude.is_a?(Float)
          raise ArgumentError('Latitude must be Integer or Float')
        end
        unless latitude >= -90 && latitude <= 90
          raise ArgumentError('Latitude must be between -90 and 90')
        end

        @latitude = latitude
        self
      end

      def with_longitude(longitude)
        unless longitude.is_a?(Integer) || longitude.is_a?(Float)
          raise ArgumentError('Longitude must be Integer or Float')
        end
        unless longitude >= -90 && longitude <= 90
          raise ArgumentError('Longitude must be between -90 and 90')
        end

        @longitude = longitude
        self
      end

      def with_radius(radius)
        unless radius.is_a?(Integer) || radius.is_a?(Float)
          raise ArgumentError('Radius must be Integer or Float')
        end
        raise ArgumentError('Radius must be >= 0') unless radius >= 0

        @radius = radius
        self
      end

      def with_uncertainty(uncertainty)
        unless uncertainty.is_a?(Integer) || uncertainty.is_a?(Float)
          raise ArgumentError('Uncertainty must be Integer or Float')
        end
        raise ArgumentError('Uncertainty must be >= 0') unless uncertainty >= 0

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
