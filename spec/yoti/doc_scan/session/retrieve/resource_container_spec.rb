require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::ResourceContainer' do
  let(:resource_container) do
    Yoti::DocScan::Session::Retrieve::ResourceContainer.new(
      'id_documents' => [
        {},
        {}
      ],
      'liveness_capture' => [
        {
          'liveness_type' => 'ZOOM'
        },
        {
          'liveness_type' => 'SOME_UNKNOWN_LIVENESS_TYPE'
        }
      ]
    )
  end

  describe '.id_documents' do
    describe 'when ID documents are available' do
      it 'should return ID documents' do
        documents = resource_container.id_documents
        expect(documents.count).to eql(2)
        expect(documents).to all(be_a(Yoti::DocScan::Session::Retrieve::IdDocumentResourceResponse))
      end
    end

    describe 'when ID documents are not available' do
      it 'should return empty array' do
        resource_container = Yoti::DocScan::Session::Retrieve::ResourceContainer.new({})
        documents = resource_container.id_documents
        expect(documents).to be_a(Array)
        expect(documents.count).to eql(0)
      end
    end
  end

  describe '.liveness_capture' do
    describe 'when liveness capture is available' do
      it 'should return array of liveness resource response' do
        liveness_capture = resource_container.liveness_capture
        expect(liveness_capture.count).to eql(2)
        expect(liveness_capture).to all(be_a(Yoti::DocScan::Session::Retrieve::LivenessResourceResponse))
        expect(liveness_capture[0]).to be_a(Yoti::DocScan::Session::Retrieve::ZoomLivenessResourceResponse)
      end
      it 'should return zoom liveness resource response' do
        zoom_liveness_capture = resource_container.liveness_capture[0]
        expect(zoom_liveness_capture.liveness_type).to eql('ZOOM')
      end
      it 'should return unknown liveness resource response' do
        liveness_capture = resource_container.liveness_capture[1]
        expect(liveness_capture.liveness_type).to eql('SOME_UNKNOWN_LIVENESS_TYPE')
      end
    end

    describe 'when liveness capture is not available' do
      it 'should return empty array' do
        resource_container = Yoti::DocScan::Session::Retrieve::ResourceContainer.new({})
        liveness_capture = resource_container.liveness_capture
        expect(liveness_capture).to be_a(Array)
        expect(liveness_capture.count).to eql(0)
      end
    end
  end

  describe '.zoom_liveness_resources' do
    it 'should return array of ZoomLivenessResourceResponse' do
      zoom_liveness_resources = resource_container.zoom_liveness_resources
      expect(zoom_liveness_resources.count).to eql(1)
      expect(zoom_liveness_resources[0]).to be_a(Yoti::DocScan::Session::Retrieve::ZoomLivenessResourceResponse)
    end
  end
end
