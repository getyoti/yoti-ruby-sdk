describe 'Yoti::DocScan::Session::Create::RequiredIdDocument' do
  describe 'without filter' do
    it 'serializes correctly' do
      document = Yoti::DocScan::Session::Create::RequiredIdDocument
                 .builder
                 .build

      expected = {
        type: 'ID_DOCUMENT'
      }

      expect(document.to_json).to eql expected.to_json
    end
  end

  describe 'with filter' do
    it 'serializes correctly' do
      some_filter = Yoti::DocScan::Session::Create::DocumentRestrictionsFilter
                    .builder
                    .for_whitelist
                    .build

      document = Yoti::DocScan::Session::Create::RequiredIdDocument
                 .builder
                 .with_filter(some_filter)
                 .build

      expected = {
        type: 'ID_DOCUMENT',
        filter: some_filter
      }

      expect(document.to_json).to eql expected.to_json
    end
  end
end
