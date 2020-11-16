describe 'Yoti::DocScan::Session::Create::RequiredSupplementaryDocument' do
  let(:some_objective) do
    Yoti::DocScan::Session::Create::ProofOfAddressObjective
      .builder
      .build
  end

  let(:some_document_types) { %w[SOME_TYPE SOME_OTHER_TYPE] }
  let(:some_country_codes) { %w[SOME_COUNTRY SOME_OTHER_COUNTRY] }

  describe 'with objective' do
    it 'serializes correctly' do
      document = Yoti::DocScan::Session::Create::RequiredSupplementaryDocument
                 .builder
                 .with_objective(some_objective)
                 .build

      expected = {
        type: 'SUPPLEMENTARY_DOCUMENT',
        objective: some_objective
      }

      expect(document.to_json).to eql expected.to_json
    end
  end

  describe 'without objective' do
    it 'raises argument error' do
      expect do
        Yoti::DocScan::Session::Create::RequiredSupplementaryDocument
          .builder
          .build
      end.to raise_error(
        ArgumentError,
        'objective must be a Yoti::DocScan::Session::Create::Objective'
      )
    end
  end

  describe 'with country codes' do
    it 'serializes correctly' do
      document = Yoti::DocScan::Session::Create::RequiredSupplementaryDocument
                 .builder
                 .with_objective(some_objective)
                 .with_country_codes(some_country_codes)
                 .build

      expected = {
        type: 'SUPPLEMENTARY_DOCUMENT',
        objective: some_objective,
        country_codes: some_country_codes
      }

      expect(document.to_json).to eql expected.to_json
    end
  end

  describe 'with document types' do
    it 'serializes correctly' do
      document = Yoti::DocScan::Session::Create::RequiredSupplementaryDocument
                 .builder
                 .with_objective(some_objective)
                 .with_document_types(some_document_types)
                 .build

      expected = {
        type: 'SUPPLEMENTARY_DOCUMENT',
        objective: some_objective,
        document_types: some_document_types
      }

      expect(document.to_json).to eql expected.to_json
    end
  end
end
