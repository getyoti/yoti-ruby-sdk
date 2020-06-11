describe 'Yoti::Validation' do
  let(:some_string) { 'some_string' }
  let(:some_name) { 'some_name' }

  describe '.assert_is_a' do
    context 'when value is valid' do
      it 'should not raise error' do
        [
          [some_string, String],
          [123, Integer],
          [{}, Hash],
          [[], Array]
        ].each do |value, type|
          expect { Yoti::Validation.assert_is_a(type, value, some_name) }
            .not_to raise_error
        end
      end
    end
    context 'when value is invalid' do
      it 'should raise error' do
        expect { Yoti::Validation.assert_is_a(Integer, some_string, some_name) }
          .to raise_error(ArgumentError, "#{some_name} must be a Integer")
      end
    end
  end

  describe '.assert_not_nil' do
    context 'when value not nil' do
      it 'should not raise error' do
        expect { Yoti::Validation.assert_not_nil(some_string, some_name) }
          .not_to raise_error
      end
    end
    context 'when value is nil' do
      it 'should raise error' do
        expect { Yoti::Validation.assert_not_nil(nil, some_name) }
          .to raise_error(ArgumentError, "#{some_name} must not be nil")
      end
    end
  end

  describe '.assert_respond_to' do
    context 'when value does respond to method' do
      it 'should not raise error' do
        expect { Yoti::Validation.assert_respond_to(:to_s, some_string, some_name) }
          .not_to raise_error
      end
    end
    context 'when value does not respond to method' do
      it 'should raise error' do
        expect { Yoti::Validation.assert_respond_to(:unknown_method, some_string, some_name) }
          .to raise_error(ArgumentError, "#{some_name} must respond to unknown_method")
      end
    end
  end
end
