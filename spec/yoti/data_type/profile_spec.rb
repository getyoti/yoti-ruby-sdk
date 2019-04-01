describe 'Yoti::Profile' do
  profile_data = { Yoti::Attribute::SELFIE => 'test_selfie',
                   Yoti::Attribute::FAMILY_NAME => 'test_family_name',
                   Yoti::Attribute::GIVEN_NAMES => 'test_given_names',
                   Yoti::Attribute::FULL_NAME => 'test_full_name',
                   Yoti::Attribute::PHONE_NUMBER => 'test_phone_number',
                   Yoti::Attribute::EMAIL_ADDRESS => 'test_email_address',
                   Yoti::Attribute::DATE_OF_BIRTH => 'test_date_of_birth',
                   Yoti::Attribute::GENDER => 'test_gender',
                   Yoti::Attribute::NATIONALITY => 'test_nationality',
                   Yoti::Attribute::POSTAL_ADDRESS => 'test_postal_address',
                   Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS => 'test_structured_address' }

  profile = Yoti::Profile.new(profile_data)

  describe '.selfie' do
    it 'should return test_selfie' do
      expect(profile.selfie).to eql('test_selfie')
    end
  end

  describe '.family_name' do
    it 'should return test_family_name' do
      expect(profile.family_name).to eql('test_family_name')
    end
  end

  describe '.given_names' do
    it 'should return test_given_names' do
      expect(profile.given_names).to eql('test_given_names')
    end
  end

  describe '.full_name' do
    it 'should return test_full_name' do
      expect(profile.full_name).to eql('test_full_name')
    end
  end

  describe '.phone_number' do
    it 'should return test_phone_number' do
      expect(profile.phone_number).to eql('test_phone_number')
    end
  end

  describe '.test_email_address' do
    it 'should return test_email_address' do
      expect(profile.email_address).to eql('test_email_address')
    end
  end

  describe '.date_of_birth' do
    it 'should return test_date_of_birth' do
      expect(profile.date_of_birth).to eql('test_date_of_birth')
    end
  end

  describe '.gender' do
    it 'should return test_gender' do
      expect(profile.gender).to eql('test_gender')
    end
  end

  describe '.nationality' do
    it 'should return test_nationality' do
      expect(profile.nationality).to eql('test_nationality')
    end
  end

  describe '.postal_address' do
    it 'should return test_postal_address' do
      expect(profile.postal_address).to eql('test_postal_address')
    end
    it 'should return formatted address when postal address not available' do
      structured_address_attribute = Yoti::Attribute.new(
        Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS,
        { 'formatted_address' => 'test_structured_address' },
        'test_sources',
        'test_verifiers'
      )

      formatted_address_profile = Yoti::Profile.new(
        Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS => structured_address_attribute
      )

      expect(formatted_address_profile.postal_address.name).to eql(Yoti::Attribute::POSTAL_ADDRESS)
      expect(formatted_address_profile.postal_address.sources).to eql('test_sources')
      expect(formatted_address_profile.postal_address.verifiers).to eql('test_verifiers')
      expect(formatted_address_profile.postal_address.value).to eql('test_structured_address')
    end
  end

  describe '.structured_postal_address' do
    it 'should return test_structured_address' do
      expect(profile.structured_postal_address).to eql('test_structured_address')
    end
  end

  describe '.get_attribute' do
    profile_data.each do |key, value|
      it "'#{key}' should return '#{value}''" do
        expect(profile.get_attribute(key)).to eql(value)
      end
    end
  end
end
