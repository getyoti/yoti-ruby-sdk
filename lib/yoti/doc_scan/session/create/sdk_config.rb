# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class SdkConfig
          #
          # @param [String] allowed_capture_methods
          # @param [String] primary_colour
          # @param [String] secondary_colour
          # @param [String] font_colour
          # @param [String] locale
          # @param [String] preset_issuing_country
          # @param [String] success_url
          # @param [String] error_url
          #
          def initialize(
            allowed_capture_methods,
            primary_colour,
            secondary_colour,
            font_colour,
            locale,
            preset_issuing_country,
            success_url,
            error_url
          )
            Validation.assert_is_a(String, allowed_capture_methods, 'allowed_capture_methods', true)
            @allowed_capture_methods = allowed_capture_methods

            Validation.assert_is_a(String, primary_colour, 'primary_colour', true)
            @primary_colour = primary_colour

            Validation.assert_is_a(String, secondary_colour, 'secondary_colour', true)
            @secondary_colour = secondary_colour

            Validation.assert_is_a(String, font_colour, 'font_colour', true)
            @font_colour = font_colour

            Validation.assert_is_a(String, locale, 'locale', true)
            @locale = locale

            Validation.assert_is_a(String, preset_issuing_country, 'preset_issuing_country', true)
            @preset_issuing_country = preset_issuing_country

            Validation.assert_is_a(String, success_url, 'success_url', true)
            @success_url = success_url

            Validation.assert_is_a(String, error_url, 'error_url', true)
            @error_url = error_url
          end

          def to_json(*_args)
            as_json.to_json
          end

          def as_json(*_args)
            {
              allowed_capture_methods: @allowed_capture_methods,
              primary_colour: @primary_colour,
              secondary_colour: @secondary_colour,
              font_colour: @font_colour,
              locale: @locale,
              preset_issuing_country: @preset_issuing_country,
              success_url: @success_url,
              error_url: @error_url
            }.compact
          end

          #
          # @return [SdkConfigBuilder]
          #
          def self.builder
            SdkConfigBuilder.new
          end
        end

        #
        # Builder to assist in the creation of {SdkConfig}.
        #
        class SdkConfigBuilder
          def initialize
            @topics = []
          end

          #
          # Sets the allowed capture method to "CAMERA"
          #
          # @return [self]
          #
          def with_allows_camera
            with_allowed_capture_methods(Constants::CAMERA)
          end

          #
          # Sets the allowed capture method to "CAMERA_AND_UPLOAD"
          #
          # @return [self]
          #
          def with_allows_camera_and_upload
            with_allowed_capture_methods(Constants::CAMERA_AND_UPLOAD)
          end

          #
          # Sets the allowed capture method
          #
          # @param [String] allowed_capture_methods
          #
          # @return [self]
          #
          def with_allowed_capture_methods(allowed_capture_methods)
            @allowed_capture_methods = allowed_capture_methods
            self
          end

          #
          # Sets the primary colour to be used by the web/native client
          #
          # @param [String] primary_colour
          #
          # @return [self]
          #
          def with_primary_colour(primary_colour)
            @primary_colour = primary_colour
            self
          end

          #
          # Sets the secondary colour to be used by the web/native client (used on the button)
          #
          # @param [String] secondary_colour
          #
          # @return [self]
          #
          def with_secondary_colour(secondary_colour)
            @secondary_colour = secondary_colour
            self
          end

          #
          # Sets the font colour to be used by the web/native client (used on the button)
          #
          # @param [String] font_colour
          #
          # @return [self]
          #
          def with_font_colour(font_colour)
            @font_colour = font_colour
            self
          end

          #
          # Sets the locale on the builder
          #
          # @param [String] locale
          #
          # @return [self]
          #
          def with_locale(locale)
            @locale = locale
            self
          end

          #
          # Sets the preset issuing country on the builder
          #
          # @param [String] preset_issuing_country
          #
          # @return [self]
          #
          def with_preset_issuing_country(preset_issuing_country)
            @preset_issuing_country = preset_issuing_country
            self
          end

          #
          # Sets the success URL for the redirect that follows the web/native client
          # uploading documents successfully
          #
          # @param [String] success_url
          #
          # @return [self]
          #
          def with_success_url(success_url)
            @success_url = success_url
            self
          end

          #
          # Sets the error URL for the redirect that follows the web/native client
          # uploading documents unsuccessfully
          #
          # @param [String] error_url
          #
          # @return [self]
          #
          def with_error_url(error_url)
            @error_url = error_url
            self
          end

          #
          # @return [SdkConfig]
          #
          def build
            SdkConfig.new(
              @allowed_capture_methods,
              @primary_colour,
              @secondary_colour,
              @font_colour,
              @locale,
              @preset_issuing_country,
              @success_url,
              @error_url
            )
          end
        end
      end
    end
  end
end
