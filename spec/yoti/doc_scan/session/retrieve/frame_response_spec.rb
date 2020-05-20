require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::FrameResponse' do
  let(:frame_response) do
    Yoti::DocScan::Session::Retrieve::FrameResponse.new(
      'media' => {}
    )
  end

  describe '.media' do
    it 'should return media' do
      expect(frame_response.media).to be_a(Yoti::DocScan::Session::Retrieve::MediaResponse)
    end
  end
end
