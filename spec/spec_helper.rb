require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'webmock/rspec'

require 'yoti'

def stub_api_requests_v1(method = :get, response = 'profile', endpoint = '[a-zA-Z]*', status = [200])
  stub_response = File.read("spec/sample-data/responses/#{response}.json")
  stub_request(method, %r{https:\/\/api.yoti.com\/api\/v1\/#{endpoint}\/(.)*})
    .to_return(
      status: status,
      body: stub_response,
      headers: { 'Content-Type' => 'application/json' }
    )
end

RSpec.configure do |config|
  config.before(:each, type: :api_with_profile) do
    stub_api_requests_v1(:get, 'profile', 'profile')
  end

  config.before(:each, type: :api_with_empty_profile) do
    stub_api_requests_v1(:get, 'profile_empty', 'profile')
  end

  config.before(:each, type: :api_with_null_profile) do
    stub_api_requests_v1(:get, 'profile_null', 'profile')
  end

  config.before(:each, type: :api_without_profile) do
    stub_api_requests_v1(:get, 'profile_missing', 'profile')
  end

  config.before(:each, type: :api_empty) do
    stub_api_requests_v1(:get, 'empty')
  end

  config.before(:each, type: :api_error) do
    stub_api_requests_v1(:get, 'profile_error', nil, %w[401 Error])
  end

  config.before(:each, type: :api_aml_check) do
    stub_api_requests_v1(:post, 'aml_check', 'aml-check')
  end

  config.before do
    initialize_test_app
  end
end

def initialize_test_app
  clear_config

  Yoti.configure do |config|
    config.client_sdk_id = 'stub_yoti_client_sdk_id'
    config.key_file_path = 'spec/sample-data/ruby-sdk-test.pem'
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
