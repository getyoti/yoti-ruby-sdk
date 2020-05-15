# frozen_string_literal: true

module Yoti
  module DocScan
    module Session
      module Create
        class SdkConfig
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

          def to_json(*args)
            as_json.to_json(*args)
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

          def self.builder
            SdkConfigBuilder.new
          end
        end

        class SdkConfigBuilder
          def initialize
            @topics = []
          end

          def with_allows_camera
            with_allowed_capture_methods(Constants::CAMERA)
          end

          def with_allows_camera_and_upload
            with_allowed_capture_methods(Constants::CAMERA_AND_UPLOAD)
          end

          def with_allowed_capture_methods(allowed_capture_methods)
            @allowed_capture_methods = allowed_capture_methods
            self
          end

          def with_primary_colour(primary_colour)
            @primary_colour = primary_colour
            self
          end

          def with_secondary_colour(secondary_colour)
            @secondary_colour = secondary_colour
            self
          end

          def with_font_colour(font_colour)
            @font_colour = font_colour
            self
          end

          def with_locale(locale)
            @locale = locale
            self
          end

          def with_preset_issuing_country(preset_issuing_country)
            @preset_issuing_country = preset_issuing_country
            self
          end

          def with_success_url(success_url)
            @success_url = success_url
            self
          end

          def with_error_url(error_url)
            @error_url = error_url
            self
          end

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
