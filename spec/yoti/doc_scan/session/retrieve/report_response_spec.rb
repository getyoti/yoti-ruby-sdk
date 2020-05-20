require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::ReportResponse' do
  let(:report_response) do
    Yoti::DocScan::Session::Retrieve::ReportResponse.new(
      'recommendation' => {},
      'breakdown' => [
        {},
        {}
      ]
    )
  end

  describe '.recommendation' do
    it 'should return recommendation' do
      expect(report_response.recommendation).to be_a(Yoti::DocScan::Session::Retrieve::RecommendationResponse)
    end
  end

  describe '.breakdown' do
    it 'should return array of breakdown' do
      breakdown_items = report_response.breakdown
      expect(breakdown_items.count).to be(2)
      expect(breakdown_items).to all(be_a(Yoti::DocScan::Session::Retrieve::BreakdownResponse))
    end
  end
end
