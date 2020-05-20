require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::FaceMapResponse' do
  let(:face_map_response) do
    Yoti::DocScan::Session::Retrieve::FaceMapResponse.new(
      'media' => {}
    )
  end

  describe '.media' do
    it 'should return media' do
      expect(face_map_response.media).to be_a(Yoti::DocScan::Session::Retrieve::MediaResponse)
    end
  end
end
