describe 'Yoti::DocScan::Session::Create::ProofOfAddressObjective' do
  it 'serializes correctly' do
    objective = Yoti::DocScan::Session::Create::ProofOfAddressObjective
                .builder
                .build

    expected = {
      type: 'PROOF_OF_ADDRESS'
    }

    expect(objective.to_json).to eql expected.to_json
  end
end
