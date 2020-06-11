describe 'Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter' do
  let(:some_country_codes) { %w[some_country_code some_other_country_code] }
  let(:some_document_types) { %w[some_document_type some_other_document_type] }

  describe 'with country and type restrictions' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
               .builder
               .with_included_countries(some_country_codes)
               .with_included_document_types(some_document_types)
               .build

      expected = {
        type: 'ORTHOGONAL_RESTRICTIONS',
        country_restriction: {
          inclusion: 'WHITELIST',
          country_codes: some_country_codes
        },
        type_restriction: {
          inclusion: 'WHITELIST',
          document_types: some_document_types
        }
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end

  describe 'with excluded countries' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
               .builder
               .with_excluded_countries(some_country_codes)
               .build

      expected = {
        type: 'ORTHOGONAL_RESTRICTIONS',
        country_restriction: {
          inclusion: 'BLACKLIST',
          country_codes: some_country_codes
        }
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end

  describe 'with excluded document types' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
               .builder
               .with_excluded_document_types(some_document_types)
               .build

      expected = {
        type: 'ORTHOGONAL_RESTRICTIONS',
        type_restriction: {
          inclusion: 'BLACKLIST',
          document_types: some_document_types
        }
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end

  describe 'with included document types' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
               .builder
               .with_included_document_types(some_document_types)
               .build

      expected = {
        type: 'ORTHOGONAL_RESTRICTIONS',
        type_restriction: {
          inclusion: 'WHITELIST',
          document_types: some_document_types
        }
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end

  describe 'with included countries' do
    it 'serializes correctly' do
      filter = Yoti::DocScan::Session::Create::OrthogonalRestrictionsFilter
               .builder
               .with_included_countries(some_country_codes)
               .build

      expected = {
        type: 'ORTHOGONAL_RESTRICTIONS',
        country_restriction: {
          inclusion: 'WHITELIST',
          country_codes: some_country_codes
        }
      }

      expect(filter.to_json).to eql expected.to_json
    end
  end
end
