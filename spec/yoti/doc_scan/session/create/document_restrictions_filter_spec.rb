describe 'Yoti::DocScan::Session::Create::DocumentRestrictionsFilter' do
  let(:some_restriction) do
    Yoti::DocScan::Session::Create::DocumentRestriction
      .builder
      .with_countries(['some_country_code'])
      .build
  end

  describe 'for inclusion' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::DocumentRestrictionsFilter
               .builder
               .for_inclusion
               .build

      expected = {
        type: 'DOCUMENT_RESTRICTIONS',
        inclusion: 'WHITELIST',
        documents: []
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end
  describe 'for inclusion with restriction' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::DocumentRestrictionsFilter
               .builder
               .for_inclusion
               .with_document_restriction(some_restriction)
               .build

      expected = {
        type: 'DOCUMENT_RESTRICTIONS',
        inclusion: 'WHITELIST',
        documents: [some_restriction]
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end
  describe 'for exclusion' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::DocumentRestrictionsFilter
               .builder
               .for_exclusion
               .build

      expected = {
        type: 'DOCUMENT_RESTRICTIONS',
        inclusion: 'BLACKLIST',
        documents: []
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end
end
