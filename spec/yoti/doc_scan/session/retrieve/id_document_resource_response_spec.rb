require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::IdDocumentResourceResponse' do
  let(:resource_response) do
    Yoti::DocScan::Session::Retrieve::IdDocumentResourceResponse.new(
      'document_type' => 'some-type',
      'issuing_country' => 'some-country',
      'pages' => [{
        'someDetail' => 'some-value'
      }],
      'document_fields' => {},
      'tasks' => [
        {
          'type' => 'ID_DOCUMENT_TEXT_DATA_EXTRACTION'
        },
        {
          'type' => 'SOME_UNKNOWN_TYPE'
        }
      ]
    )
  end

  describe '.document_type' do
    it 'should return document type' do
      expect(resource_response.document_type).to eql('some-type')
    end
  end

  describe '.issuing_country' do
    it 'should return issuing country' do
      expect(resource_response.issuing_country).to eql('some-country')
    end
  end

  describe '.pages' do
    it 'should return array of pages' do
      expect(resource_response.pages.count).to eql(1)
      expect(resource_response.pages).to all(be_a(Yoti::DocScan::Session::Retrieve::PageResponse))
    end
  end

  describe '.document_fields' do
    it 'should return document fields' do
      expect(resource_response.document_fields).to be_a(Yoti::DocScan::Session::Retrieve::DocumentFieldsResponse)
    end
  end

  describe '.tasks' do
    it 'should return array of tasks' do
      expect(resource_response.tasks).to all(be_a(Yoti::DocScan::Session::Retrieve::TaskResponse))
    end
  end

  describe '.text_extraction_tasks' do
    it 'should return array of text extraction tasks' do
      expect(resource_response.text_extraction_tasks).to all(be_a(Yoti::DocScan::Session::Retrieve::TextExtractionTaskResponse))
    end
  end
end
