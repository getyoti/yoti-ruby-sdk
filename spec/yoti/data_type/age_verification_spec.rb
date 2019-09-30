# const EXPECTED_PATTERN = /^[^:]+:(?!.*:)[0-9]+$/;

describe 'Yoti::AgeVerification' do
  describe 'when malformed age derivation is provided' do
    it 'should throw exception' do
      [
        '',
        ':',
        '18',
        'age_over:',
        'age_over:not_int',
        ':age_over:18',
        'age_over::18',
        'age_over:18:',
        'age_over:18:21'
      ].each do |name|
        attribute = Yoti::Attribute.new(name, 'true', [], [])
        expect { Yoti::AgeVerification.new(attribute) }.to raise_error(ArgumentError, "'#{name}' is not a valid age verification")
      end
    end
  end

  describe 'when well formed age derivation is provided' do
    attribute = Yoti::Attribute.new('any_string_here:21', 'true', [], [])
    age_verification = Yoti::AgeVerification.new(attribute)

    it 'should parse check type' do
      expect(age_verification.check_type).to eql('any_string_here')
    end
    it 'should parse age' do
      expect(age_verification.age).to eql(21)
    end
    it 'should parse result' do
      expect(age_verification.result).to eql(true)
    end
    it 'should return provided attribute' do
      expect(age_verification.attribute).to eql(attribute)
    end
  end
end
