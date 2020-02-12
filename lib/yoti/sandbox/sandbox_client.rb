# frozen_string_literal: true

module Sandbox
  # Client is responsible for setting up test data in the sandbox instance
  class Client
    attr_accessor :base_url

    def initialize(base_url:)
      @base_url = base_url
    end

    def setup_sharing_profile(profile)
      endpoint = "/apps/#{Yoti.configuration.client_sdk_id}/tokens?\
nonce=#{SecureRandom.uuid}&timestamp=#{Time.now.to_i}"
      uri = URI(
        "#{@base_url}/#{endpoint}"
      )

      response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true
      ) do |http|
        unsigned = Net::HTTP::Post.new uri
        unsigned.body = profile.to_json
        signed_request = Yoti::SignedRequest.new(
          unsigned,
          endpoint,
          profile
        ).sign
        http.request signed_request
      end

      raise "Failed to share profile #{response.code}: #{response.body}" unless response.code == '201'

      token = JSON.parse(response.body)['token']
      token
    end
  end
end
