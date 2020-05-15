describe 'Yoti::DocScan::Session::Create::RequestedCheck' do
  it 'cannot be instantiated' do
    expect { Yoti::DocScan::Session::Create::RequestedCheck.new('', '') }
      .to raise_error(
        TypeError,
        'Yoti::DocScan::Session::Create::RequestedCheck cannot be instantiated'
      )
  end
end
