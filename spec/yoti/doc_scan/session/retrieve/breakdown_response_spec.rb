require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::BreakdownResponse' do
  let(:breakdown_response) do
    Yoti::DocScan::Session::Retrieve::BreakdownResponse.new(
      'sub_check' => 'some-sub-check',
      'result' => 'some-result',
      'details' => [{}]
    )
  end

  describe '.sub_check' do
    it 'should return sub check' do
      expect(breakdown_response.sub_check).to eql('some-sub-check')
    end
  end

  describe '.result' do
    it 'should return result' do
      expect(breakdown_response.result).to eql('some-result')
    end
  end

  describe '.details' do
    describe 'when details are available' do
      it 'should return array of details' do
        details = breakdown_response.details
        expect(details.count).to eql(1)
        expect(details[0]).to be_a(Yoti::DocScan::Session::Retrieve::DetailsResponse)
      end
    end

    describe 'when details are not available' do
      it 'should return an empty array' do
        breakdown_response = Yoti::DocScan::Session::Retrieve::BreakdownResponse.new({})
        details = breakdown_response.details
        expect(details).to be_a(Array)
        expect(details.count).to eql(0)
      end
    end
  end
end
