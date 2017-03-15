require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'webmock/rspec'

require 'yoti'

def stub_api_requests_v1(payload = 'payload_v1')
  response = File.read("spec/fixtures/#{payload}.json")
  stub_request(:get, %r{https:\/\/api.yoti.com\/api\/v1\/profile\/(.)*})
    .to_return(
      status: 200,
      body: response,
      headers: { 'Content-Type' => 'application/json' }
    )
end

RSpec.configure do |config|
  config.before(:each, type: :api_with_profile) do
    stub_api_requests_v1
  end

  config.before(:each, type: :api_with_empty_profile) do
    stub_api_requests_v1('payload_v1_empty_profile')
  end

  config.before(:each, type: :api_with_null_profile) do
    stub_api_requests_v1('payload_v1_null_profile')
  end

  config.before(:each, type: :api_without_profile) do
    stub_api_requests_v1('payload_v1_no_profile')
  end

  config.before do
    initialize_test_app
  end
end

def initialize_test_app
  clear_config

  Yoti.configure do |config|
    config.client_sdk_id = 'stub_yoti_client_sdk_id'
    config.key_file_path = 'spec/fixtures/ruby-sdk-test.pem'
  end
end

def clear_config
  Yoti.configuration = nil
end

def clear_ssl
  Yoti::SSL.instance_variable_set(:@pem, nil)
  Yoti::SSL.instance_variable_set(:@private_key, nil)
  initialize_test_app
end
