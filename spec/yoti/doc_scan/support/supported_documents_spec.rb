require 'spec_helper'

describe 'Yoti::DocScan::Support::SupportedDocumentsResponse' do
  describe 'when response has supported countries' do
    let(:response) do
      Yoti::DocScan::Support::SupportedDocumentsResponse.new(
        'supported_countries' => [
          {
            'code' => 'SOME_COUNTRY_CODE',
            'supported_documents' => [
              {
                'type' => 'SOME_DOCUMENT_TYPE'
              }
            ]
          },
          {
            'code' => 'SOME_OTHER_COUNTRY_CODE',
            'supported_documents' => [
              {
                'type' => 'SOME_DOCUMENT_TYPE'
              },
              {
                'type' => 'SOME_OTHER_DOCUMENT_TYPE'
              }
            ]
          },
          {
            'code' => 'SOME_OTHER_COUNTRY_CODE'
          }
        ]
      )
    end

    it 'parses response into list of supported countries' do
      supported_countries = response.supported_countries

      expect(supported_countries.count).to eql(3)

      expect(supported_countries[0].code).to eql('SOME_COUNTRY_CODE')
      expect(supported_countries[0].supported_documents.count).to eql(1)
      expect(supported_countries[0].supported_documents[0].type).to eql('SOME_DOCUMENT_TYPE')

      expect(supported_countries[1].code).to eql('SOME_OTHER_COUNTRY_CODE')
      expect(supported_countries[1].supported_documents.count).to eql(2)
      expect(supported_countries[1].supported_documents[0].type).to eql('SOME_DOCUMENT_TYPE')
      expect(supported_countries[1].supported_documents[1].type).to eql('SOME_OTHER_DOCUMENT_TYPE')

      expect(supported_countries[2].code).to eql('SOME_OTHER_COUNTRY_CODE')
      expect(supported_countries[2].supported_documents.count).to eql(0)
    end
  end

  describe 'when response has no supported countries' do
    let(:response) do
      Yoti::DocScan::Support::SupportedDocumentsResponse.new({})
    end

    it 'should return empty list' do
      expect(response.supported_countries.count).to eql(0)
    end
  end
end
