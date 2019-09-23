# frozen_string_literal: true

module Yoti
  module DynamicSharingService
    class Share
      attr_reader :share_url, :ref_id

      def initialize(data)
        @share_url = data['qrcode']
        @ref_id = data['ref_id']
      end
    end

    def self.create_share_url_endpoint
      "/qrcodes/apps/#{Yoti.configuration.client_sdk_id}"
    end

    def self.create_share_url_query
      "?nonce=#{SecureRandom.uuid}&timestamp=#{Time.now.to_i}"
    end

    def self.create_share_url(scenario)
      endpoint = "#{create_share_url_endpoint}#{create_share_url_query}"
      uri = URI("#{Yoti.configuration.api_endpoint}#{endpoint}")

      unsigned = Net::HTTP::Post.new uri
      unsigned.body = scenario.to_json

      signed_request = Yoti::SignedRequest.new(
        unsigned,
        endpoint,
        scenario
      ).sign

      response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true
      ) do |http|
        http.request signed_request
      end

      if response.code.to_i < 200 || response.code.to_i >= 300
        case response.code
        when '400'
          raise InvalidDataError
        when '404'
          raise ApplicationNotFoundError
        else
          raise UnknownHTTPError, response.code
        end
      end

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
  end
end
