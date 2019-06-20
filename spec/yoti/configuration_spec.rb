require 'spec_helper'

describe 'Yoti::Configuration' do
  let(:configuration) { Yoti::Configuration.new }

  describe '#initialize' do
    it 'sets the instance variables' do
      configuration.client_sdk_id = 'client_sdk_id'
      configuration.key_file_path = 'key_file_path'
      configuration.sdk_identifier = 'sdk_identifier'
      configuration.key = 'key'
      configuration.api_url = 'https://api_url.com'
      configuration.api_port = 'api_port'
      configuration.api_version = 'v1'

      expect(configuration.client_sdk_id).to eql('client_sdk_id')
      expect(configuration.key_file_path).to eql('key_file_path')
      expect(configuration.sdk_identifier).to eql('sdk_identifier')
      expect(configuration.key).to eql('key')
      expect(configuration.api_url).to eql('https://api_url.com')
      expect(configuration.api_port).to eql('api_port')
      expect(configuration.api_version).to eql('v1')
    end

    it 'uses default values' do
      expect(configuration.api_url).to eql('https://api.yoti.com')
      expect(configuration.api_port).to eql(443)
      expect(configuration.api_version).to eql('v1')
      expect(configuration.sdk_identifier).to eql('Ruby')
    end
  end

  describe '#api_endpoint' do
    it 'sets the instance variables' do
      configuration.client_sdk_id = 'client_sdk_id'
      configuration.key = 'key'
      configuration.api_url = 'https://api_url.com'
      configuration.api_version = 'v1'

      expect(configuration.api_endpoint).to eql('https://api_url.com/api/v1')

      configuration.api_endpoint = 'https://full_api_url.com'

      expect(configuration.api_endpoint).to eql('https://full_api_url.com')
    end
  end

  describe '#validate' do
    context 'with an invalid version value' do
      it 'raises Yoti::ConfigurationError' do
        configuration.client_sdk_id = 'client_sdk_id'
        configuration.key_file_path = 'key_file_path'
        configuration.api_version = 'v2'

        error = 'Configuration value `v2` is not allowed for `api_version`.'
        expect { configuration.validate }.to raise_error(Yoti::ConfigurationError, error)
      end
    end

    context 'without client_sdk_id' do
      it 'raises Yoti::ConfigurationError' do
        configuration.key_file_path = 'key_file_path'

        error = 'Configuration value `client_sdk_id` is required.'
        expect { configuration.validate }.to raise_error(Yoti::ConfigurationError, error)
      end
    end

    context 'without key_file_path and key' do
      it 'raises Yoti::ConfigurationError' do
        configuration.client_sdk_id = 'client_sdk_id'

        error = 'At least one of the configuration values has to be set: `key_file_path`, `key`.'
        expect { configuration.validate }.to raise_error(Yoti::ConfigurationError, error)
      end
    end

    context 'with key and without key_file_path' do
      it 'doesn\'t raise an error' do
        configuration.client_sdk_id = 'client_sdk_id'
        configuration.key = 'key'

        expect { configuration.validate }.not_to raise_error
      end
    end

    context 'with a key_file_path and without key' do
      it 'doesn\'t raise an error' do
        configuration.client_sdk_id = 'client_sdk_id'
        configuration.key_file_path = 'key_file_path'

        expect { configuration.validate }.not_to raise_error
      end
    end
  end
end
