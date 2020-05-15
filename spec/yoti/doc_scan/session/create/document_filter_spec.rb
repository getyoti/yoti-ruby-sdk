describe 'Yoti::DocScan::Session::Create::DocumentFilter' do
  it 'cannot be instantiated' do
    expect { Yoti::DocScan::Session::Create::DocumentFilter.new('') }
      .to raise_error(
        TypeError,
        'Yoti::DocScan::Session::Create::DocumentFilter cannot be instantiated'
      )
  end
end
