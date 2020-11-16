require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::PageResponse' do
  let(:page_response) do
    Yoti::DocScan::Session::Retrieve::PageResponse.new(
      'media' => {},
      'frames' => [{}, {}]
    )
  end

  describe '.media' do
    it 'should return media' do
      expect(page_response.media).to be_a(Yoti::DocScan::Session::Retrieve::MediaResponse)
    end
  end

  describe '.frames' do
    it 'should return frames' do
      expect(page_response.frames.count).to eql(2)
      expect(page_response.frames).to all(be_a(Yoti::DocScan::Session::Retrieve::FrameResponse))
    end
  end
end
