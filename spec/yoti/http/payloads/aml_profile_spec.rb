require 'spec_helper'

describe 'Yoti::AmlProfile' do
  let(:aml_address) { Yoti::AmlAddress.new('GBR', 'W120RT') }
  let(:aml_profile) { Yoti::AmlProfile.new('John', 'Doe', aml_address, '123321') }

  describe '#initialize' do
    context 'with the correct values' do
      it 'sets the instance variables' do
        expect(aml_profile.instance_variable_get(:@given_names)).to eql('John')
        expect(aml_profile.instance_variable_get(:@family_name)).to eql('Doe')
        expect(aml_profile.instance_variable_get(:@ssn)).to eql('123321')
        expect(aml_profile.instance_variable_get(:@address)).to be_a(Yoti::AmlAddress)
      end
    end

    context 'with missing values' do
      it 'raises Yoti::AmlError' do
        error = 'The AML request requires given names, family name and an ISO 3166 3-letter code.'
        expect { Yoti::AmlProfile.new(nil, '', []) }.to raise_error(Yoti::AmlError, error)
      end
    end

    context 'with an invalid USA address values' do
      it 'raises Yoti::AmlError' do
        error = 'Request for USA require a valid SSN and post code.'
        expect { Yoti::AmlProfile.new('John', 'Doe', Yoti::AmlAddress.new('USA', 'W120RT')) }.to raise_error(Yoti::AmlError, error)
        expect { Yoti::AmlProfile.new('John', 'Doe', Yoti::AmlAddress.new('USA'), '123321') }.to raise_error(Yoti::AmlError, error)
      end
    end
  end

  describe '#payload' do
    it 'returns the payload Hash' do
      payload = {
        given_names: 'John',
        family_name: 'Doe',
        ssn: '123321',
        address: {
          country: 'GBR',
          post_code: 'W120RT'
        }
      }
      expect(aml_profile.payload).to eql(payload)
    end
  end
end
