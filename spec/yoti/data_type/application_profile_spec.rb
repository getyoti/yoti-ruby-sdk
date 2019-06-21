describe 'Yoti::ApplicationProfile' do
  profile_data = { Yoti::Attribute::APPLICATION_NAME => 'test_name',
                   Yoti::Attribute::APPLICATION_URL => 'test_url',
                   Yoti::Attribute::APPLICATION_LOGO => 'test_logo',
                   Yoti::Attribute::APPLICATION_RECEIPT_BGCOLOR => 'test_receipt_bgcolor' }

  profile = Yoti::ApplicationProfile.new(profile_data)

  describe '.name' do
    it 'should return test_name' do
      expect(profile.name).to eql('test_name')
    end
  end

  describe '.url' do
    it 'should return test_url' do
      expect(profile.url).to eql('test_url')
    end
  end

  describe '.logo' do
    it 'should return test_logo' do
      expect(profile.logo).to eql('test_logo')
    end
  end

  describe '.receipt_bgcolor' do
    it 'should return test_receipt_bgcolor' do
      expect(profile.receipt_bgcolor).to eql('test_receipt_bgcolor')
    end
  end
end
