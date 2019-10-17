# frozen_string_literal: true

require 'yoti'
require 'yoti/configuration'
require 'yoti/http/signed_request'

require_relative 'sandbox_client'
require_relative 'profile'
require_relative 'anchor'
require_relative 'attribute'

require 'openssl'
require 'net/http'
require 'date'
require 'securerandom'

require 'dotenv'
Dotenv.load

# Singleton for sandbox test resources
module Sandbox
  class << self
    attr_accessor :sandbox_client
    attr_accessor :dev_key
    attr_accessor :application
  end

  def self.setup!
    return if application

    read_dev_key!
    create_application!
    self.sandbox_client = Client.new(
      app_id: application['id'],
      private_key: application['private_key'],
      base_url: ENV['SANDBOX_BASE_URL']
    )
    configure_yoti(
      app_id: sandbox_client.app_id,
      pem: sandbox_client.key.to_pem
    )
    nil
  end

  def self.configure_yoti(app_id:, pem:)
    Yoti.configuration = Yoti::Configuration.new
    Yoti.configuration.client_sdk_id = app_id
    Yoti.configuration.key = pem
    Yoti.configuration.key_file_path = ''
    Yoti.configuration.api_endpoint = "#{ENV['SANDBOX_BASE_URL']}/"
    Yoti::SSL.reload!
  end

  def self.create_application_uri
    uri = URI(
      "#{ENV['SANDBOX_BASE_URL']}/#{ENV['SANDBOX_ENDPOINT']}?\
nonce=#{SecureRandom.uuid}&timestamp=#{Time.now.to_i}"
    )
    uri.port = 11_443
    uri
  end

  def self.create_application!
    Yoti.configure do |config|
      config.key_file_path = ENV['SANDBOX_KEY']
      config.client_sdk_id = 'DUMMY'
    end

    uri = create_application_uri
    payload = { name: "Test Run #{DateTime.now.rfc3339}" }

    response = Net::HTTP.start(
      uri.hostname,
      uri.port,
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    ) do |http|
      unsigned = Net::HTTP::Post.new uri
      unsigned.body = payload.to_json
      signed_request = Yoti::SignedRequest.new(
        unsigned,
        "#{ENV['SANDBOX_ENDPOINT']}?#{uri.query}",
        payload
      ).sign
      puts "Creating application #{signed_request.body}"
      http.request signed_request
    end

    raise "Create application failed #{response.code}: #{response.body}" unless response.code == '201'

    self.application = JSON.parse(response.body)
    nil
  end

  def self.read_dev_key!
    self.dev_key = OpenSSL::PKey::RSA.new(
      File.read(ENV['SANDBOX_KEY'], encoding: 'utf-8')
    )
    nil
  end

  def self.share(profile)
    sandbox_client.setup_sharing_profile profile
  end
end
