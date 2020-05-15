describe 'Yoti::DocScan::Session::Create::DocumentRestriction' do
  let(:some_country_codes) { %w[some_country_code some_other_country_code] }
  let(:some_document_types) { %w[some_document_type some_other_document_type] }

  describe 'with countries' do
    it 'serializes correctly' do
      restriction = Yoti::DocScan::Session::Create::DocumentRestriction
                    .builder
                    .with_countries(some_country_codes)
                    .build

      expected = {
        country_codes: some_country_codes
      }

      expect(restriction.to_json).to eql expected.to_json
    end
  end
  describe 'with document types' do
    it 'serializes correctly' do
      restriction = Yoti::DocScan::Session::Create::DocumentRestriction
                    .builder
                    .with_document_types(some_document_types)
                    .build

      expected = {
        document_types: some_document_types
      }

      expect(restriction.to_json).to eql expected.to_json
    end
  end
  describe 'with document types and countries' do
    it 'serializes correctly' do
      restriction = Yoti::DocScan::Session::Create::DocumentRestriction
                    .builder
                    .with_document_types(some_document_types)
                    .with_countries(some_country_codes)
                    .build

      expected = {
        document_types: some_document_types,
        country_codes: some_country_codes
      }

      expect(restriction.to_json).to eql expected.to_json
    end
  end
end
