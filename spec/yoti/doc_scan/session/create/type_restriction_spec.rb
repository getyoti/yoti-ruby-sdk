describe 'Yoti::DocScan::Session::Create::TypeRestriction' do
  let(:some_inclusion) { 'some_inclusion' }
  let(:some_document_types) { %w[some_document_type some_other_document_type] }

  it 'serializes correctly' do
    restriction = Yoti::DocScan::Session::Create::TypeRestriction
                  .new(some_inclusion, some_document_types)

    expected = {
      inclusion: some_inclusion,
      document_types: some_document_types
    }

    expect(restriction.to_json).to eql expected.to_json
  end
end
