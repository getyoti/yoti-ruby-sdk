require 'spec_helper'

describe 'Yoti::AmlCheckRequest' do
  let(:aml_address) { Yoti::AmlAddress.new('GBR') }
  let(:aml_profile) { Yoti::AmlProfile.new('John', 'Doe', aml_address) }
  let(:aml_check_request) { Yoti::AmlCheckRequest.new(aml_profile) }

  describe '#initialize' do
    it 'sets the instance variable @aml_profile' do
      expect(aml_check_request.instance_variable_get(:@aml_profile)).to be_a(Yoti::AmlProfile)
    end

    it 'sets the instance variable @payload' do
      expect(aml_check_request.instance_variable_get(:@payload)).to be_a(Hash)
    end

    let(:yoti_request) { aml_check_request.instance_variable_get(:@request) }

    it 'sets the instance variable @request' do
      expect(yoti_request).to be_a(Yoti::Request)
      expect(yoti_request.http_method).to eql('POST')
      expect(yoti_request.endpoint).to eql('aml-check')
      expect(yoti_request.payload).to be_a(Hash)
    end
  end

  describe '#response', type: :api_aml_check do
    let(:aml_check_response) { aml_check_request.response }

    it 'returns a Hash with the AML check keys' do
      expect(aml_check_response['on_pep_list']).to eql(true)
      expect(aml_check_response['on_fraud_list']).to eql(false)
      expect(aml_check_response['on_watch_list']).to eql(false)
    end
  end
end
