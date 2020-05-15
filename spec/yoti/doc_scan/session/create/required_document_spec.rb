describe 'Yoti::DocScan::Session::Create::RequiredDocument' do
  it 'cannot be instantiated' do
    expect { Yoti::DocScan::Session::Create::RequiredDocument.new('') }
      .to raise_error(
        TypeError,
        'Yoti::DocScan::Session::Create::RequiredDocument cannot be instantiated'
      )
  end
end
