# frozen_string_literal: true

require 'securerandom'

module Yoti
  module DynamicSharingService
    class Share
      attr_reader :share_url, :ref_id

      def initialize(data)
        @share_url = data['qrcode']
        @ref_id = data['ref_id']
      end
    end

    def self.create_share_url(scenario)
      yoti_request = Yoti::Request
                     .builder
                     .with_http_method('POST')
                     .with_base_url(Yoti.configuration.api_endpoint)
                     .with_endpoint("qrcodes/apps/#{Yoti.configuration.client_sdk_id}")
                     .with_query_param('appId', Yoti.configuration.client_sdk_id)
                     .with_payload(scenario)
                     .build

      begin
        create_share_url_parse_response yoti_request.execute
      rescue Yoti::RequestError => e
        raise if e.response.nil?

        case e.response.code
        when '400'
          raise InvalidDataError
        when '404'
          raise ApplicationNotFoundError
        else
          raise UnknownHTTPError, e.response.code
        end
      end
    end

    def self.create_share_url_parse_response(response)
      Share.new JSON.parse response.body
    end

    class InvalidDataError < StandardError
      def initialize(msg = 'JSON is incorrect, contains invalid data')
        super
      end
    end

    class ApplicationNotFoundError < StandardError
      def initialize(msg = 'Application was not found')
        super
      end
    end

    class UnknownHTTPError < StandardError
      def initialize(code = nil, msg = 'Unknown HTTP Error')
        msg = "#{msg}: #{code}" unless code.nil?
        super msg
      end
    end

    # @deprecated no longer used - will be removed in 2.0.0
    def self.create_share_url_query
      "?nonce=#{SecureRandom.uuid}&timestamp=#{Time.now.to_i}"
    end

    # @deprecated no longer used - will be removed in 2.0.0
    def self.create_share_url_endpoint
      "/qrcodes/apps/#{Yoti.configuration.client_sdk_id}"
    end
  end
end
