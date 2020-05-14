describe 'Yoti::DocScan::Session::Create::Check' do
  describe 'abstract class' do
    it 'cannot be instantiated' do
      expect { Yoti::DocScan::Session::Create::Check::RequestedCheck.new('', '') }
        .to raise_error(
          TypeError,
          'Yoti::DocScan::Session::Create::Check::RequestedCheck cannot be instantiated'
        )
    end
  end
end
