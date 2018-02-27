require 'spec_helper'

describe 'Yoti::AmlAddress' do
  let(:aml_address) { Yoti::AmlAddress.new('GBR', 'W120RT') }

  describe '#initialize' do
    it 'sets the instance variables' do
      expect(aml_address.instance_variable_get(:@country)).to eql('GBR')
      expect(aml_address.instance_variable_get(:@post_code)).to eql('W120RT')
    end
  end
end
