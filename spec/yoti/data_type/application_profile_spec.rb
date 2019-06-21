describe 'Yoti::ApplicationProfile' do
  profile_values = { Yoti::Attribute::APPLICATION_NAME => 'test_name',
                     Yoti::Attribute::APPLICATION_URL => 'test_url',
                     Yoti::Attribute::APPLICATION_LOGO => 'test_logo',
                     Yoti::Attribute::APPLICATION_RECEIPT_BGCOLOR => 'test_receipt_bgcolor' }

  profile_data = profile_values.map do |name, value|
    [name, Yoti::Attribute.new(name, value, {}, {})]
  end.to_h

  profile = Yoti::ApplicationProfile.new(profile_data)

  describe '.name' do
    it 'should return test_name' do
      expect(profile.name.value).to eql('test_name')
    end
  end

  describe '.url' do
    it 'should return test_url' do
      expect(profile.url.value).to eql('test_url')
    end
  end

  describe '.logo' do
    it 'should return test_logo' do
      expect(profile.logo.value).to eql('test_logo')
    end
  end

  describe '.receipt_bgcolor' do
    it 'should return test_receipt_bgcolor' do
      expect(profile.receipt_bgcolor.value).to eql('test_receipt_bgcolor')
    end
  end

  describe '.get_attribute' do
    profile_values.each do |key, value|
      it "'#{key}' should return '#{value}''" do
        expect(profile.get_attribute(key).value).to eql(value)
      end
    end
  end

  describe '.attributes' do
    it 'should return all attributes' do
      expect(profile.attributes.length).to eql(4)
      profile_values.each do |key, value|
        expect(profile.attributes[key].value).to eql(value)
      end
    end
  end
end
