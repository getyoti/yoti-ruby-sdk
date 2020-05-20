require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::ZoomLivenessResourceResponse' do
  let(:resource_response) do
    Yoti::DocScan::Session::Retrieve::ZoomLivenessResourceResponse.new(
      'liveness_type' => 'some-liveness-type',
      'id' => 'some-id',
      'facemap' => {},
      'frames' => [
        {},
        {}
      ]
    )
  end

  describe '.id' do
    it 'should return ID' do
      expect(resource_response.id).to eql('some-id')
    end
  end

  describe '.liveness_type' do
    it 'should return liveness type' do
      expect(resource_response.liveness_type).to eql('some-liveness-type')
    end
  end

  describe '.facemap' do
    it 'should return facemap' do
      expect(resource_response.facemap).to be_a(Yoti::DocScan::Session::Retrieve::FaceMapResponse)
    end
  end

  describe '.frames' do
    describe 'when frames are available' do
      it 'should return frames' do
        frames = resource_response.frames
        expect(frames.count).to eql(2)
        expect(frames).to all(be_a(Yoti::DocScan::Session::Retrieve::FrameResponse))
      end
    end
    describe 'when frames are not available' do
      it 'should return empty array' do
        resource_response = Yoti::DocScan::Session::Retrieve::ZoomLivenessResourceResponse.new({})
        frames = resource_response.frames
        expect(frames).to be_a(Array)
        expect(frames.count).to eql(0)
      end
    end
  end
end
