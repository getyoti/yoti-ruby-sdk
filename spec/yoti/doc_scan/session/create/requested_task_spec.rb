describe 'Yoti::DocScan::Session::Create::RequestedTask' do
  it 'cannot be instantiated' do
    expect { Yoti::DocScan::Session::Create::RequestedTask.new('', '') }
      .to raise_error(
        TypeError,
        'Yoti::DocScan::Session::Create::RequestedTask cannot be instantiated'
      )
  end
end
