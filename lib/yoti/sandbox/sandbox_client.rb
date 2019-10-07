# frozen_string_literal: true

module Sandbox
  # Client is responsible for setting up test data in the sandbox instance
  class Client
    attr_accessor :app_id
    attr_accessor :key
    attr_accessor :base_url
    attr_accessor :version_id

    def initialize(app_id:, private_key:, base_url:, version_id: "v1")
      @app_id = app_id
      @base_url = base_url
      @key = OpenSSL::PKey::RSA.new(Base64.decode64(private_key))
      @version_id = version_id
    end

    def setup_sharing_profile(profile)
      endpoint = "/apps/#{app_id}/tokens?\
nonce=#{SecureRandom.uuid}&timestamp=#{Time.now.to_i}"
      uri = URI(
        "#{@base_url}/#{@version_id}#{endpoint}"
      )

      response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true,
        verify_mode: OpenSSL::SSL::VERIFY_NONE
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
