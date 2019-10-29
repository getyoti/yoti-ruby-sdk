# frozen_string_literal: true

require 'spec_helper'

describe 'Sandbox' do
  let :app_id do
    '0000-0000-0000-0000'
  end
  let :base_url do
    'https://example.com'
  end
  let :private_key do
    key = OpenSSL::PKey::RSA.new 1024
    Base64.encode64(key.to_der)
  end
  let :profile do
    {}
  end

  describe 'self.read_dev_key!' do
    it 'Reads the private key' do
      expect(File).to receive(:read).and_return private_key
      expect { Sandbox.read_dev_key! }.to raise_error OpenSSL::PKey::RSAError
    end
  end

  describe 'self.share' do
    before do
      client = double(setup_sharing_profile: '00000')
      Sandbox.instance_variable_set(:@sandbox_client, client)
    end
    it 'Calls Sandbox::Client.share' do
      expect(Sandbox.sandbox_client).to receive(:setup_sharing_profile).with(profile)
      Sandbox.share profile
    end
  end

  describe 'self.create_application!' do
    before(:each) do
      Yoti.configuration.key = private_key
      ENV['SANDBOX_BASE_URL'] = base_url
      stub_request(:any, %r{https:\/\/}).to_return(
        status: 201,
        body: File.read('spec/sample-data/responses/sandbox_create.json'),
        headers: { 'Content-Type' => 'application/json' }
      )
    end
    it 'creates a Sandbox session' do
      log_output = StringIO.new
      Yoti::Log.output(log_output)

      Sandbox.create_application!
      expect(Sandbox.application).not_to be_nil

      expect(log_output.string).to match(/INFO -- Yoti: Creating application {"name":"Test Run \d+-\d+-\d+T\d+:\d+:\d+\+\d+:\d+"}/)
    end
  end

  describe 'self.configure_yoti' do
    it 'Sets the app ID' do
      Sandbox.configure_yoti(app_id: app_id, pem: private_key)
      expect(Yoti.configuration.client_sdk_id).not_to be_nil
    end

    it 'Sets the private key' do
      Sandbox.configure_yoti(app_id: app_id, pem: private_key)
      expect(Yoti.configuration.key).not_to be_nil
    end

    it 'Calls the SSL reload function' do
      expect(Yoti::SSL).to receive(:reload!)
      Sandbox.configure_yoti(app_id: app_id, pem: private_key)
    end
  end

  describe 'self.setup!' do
    context 'With valid dev key' do
      before :each do
        allow(Sandbox).to receive(:read_dev_key!)
        allow(Sandbox).to receive(:create_application!) {
          Sandbox.application = {}
          Sandbox.application['id'] = app_id
          Sandbox.application['private_key'] = private_key
          Sandbox.application['base_url'] = base_url
        }
        Sandbox.application = nil
      end
      it 'Configures the Sandbox session' do
        expect(Sandbox).to receive(:read_dev_key!)
        expect(Sandbox).to receive(:create_application!)
        expect(Sandbox).to receive(:configure_yoti)
        Sandbox.setup!
        expect(Sandbox.sandbox_client).not_to be_nil
      end
    end
  end
end
