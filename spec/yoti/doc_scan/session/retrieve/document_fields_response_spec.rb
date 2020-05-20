require 'spec_helper'

describe 'Yoti::DocScan::Session::Retrieve::DocumentFieldsResponse' do
  let(:document_fields_response) do
    Yoti::DocScan::Session::Retrieve::DocumentFieldsResponse.new(
      'media' => {}
    )
  end

  describe '.media' do
    it 'should return media' do
      expect(document_fields_response.media).to be_a(Yoti::DocScan::Session::Retrieve::MediaResponse)
    end
  end
end
