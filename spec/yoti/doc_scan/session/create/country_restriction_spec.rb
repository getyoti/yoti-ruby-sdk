describe 'Yoti::DocScan::Session::Create::CountryRestriction' do
  let(:some_inclusion) { 'some_inclusion' }
  let(:some_country_codes) { %w[some_country_code some_other_country_code] }

  it 'serializes correctly' do
    restriction = Yoti::DocScan::Session::Create::CountryRestriction
                  .new(some_inclusion, some_country_codes)

    expected = {
      inclusion: some_inclusion,
      country_codes: some_country_codes
    }

    expect(restriction.to_json).to eql expected.to_json
  end
end
