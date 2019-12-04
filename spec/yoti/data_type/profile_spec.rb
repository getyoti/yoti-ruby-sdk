describe 'Yoti::Profile' do
  profile_values = { Yoti::Attribute::SELFIE => 'test_selfie',
                     Yoti::Attribute::FAMILY_NAME => 'test_family_name',
                     Yoti::Attribute::GIVEN_NAMES => 'test_given_names',
                     Yoti::Attribute::FULL_NAME => 'test_full_name',
                     Yoti::Attribute::PHONE_NUMBER => 'test_phone_number',
                     Yoti::Attribute::EMAIL_ADDRESS => 'test_email_address',
                     Yoti::Attribute::DATE_OF_BIRTH => 'test_date_of_birth',
                     Yoti::Attribute::GENDER => 'test_gender',
                     Yoti::Attribute::NATIONALITY => 'test_nationality',
                     Yoti::Attribute::POSTAL_ADDRESS => 'test_postal_address',
                     Yoti::Attribute::STRUCTURED_POSTAL_ADDRESS => 'test_structured_address',
                     Yoti::Attribute::DOCUMENT_IMAGES => 'test_document_images',
                     Yoti::Attribute::DOCUMENT_DETAILS => 'test_document_details',
                     "#{Yoti::Attribute::AGE_UNDER}18" => 'false',
                     "#{Yoti::Attribute::AGE_UNDER}21" => 'true',
                     "#{Yoti::Attribute::AGE_OVER}18" => 'true',
                     "#{Yoti::Attribute::AGE_OVER}21" => 'false' }

  profile_data = profile_values.map do |name, value|
    [name, Yoti::Attribute.new(name, value, {}, {})]
  end.to_h

  profile = Yoti::Profile.new(profile_data)

  describe '.selfie' do
    it 'should return test_selfie' do
      expect(profile.selfie.value).to eql('test_selfie')
    end
  end

  describe '.family_name' do
    it 'should return test_family_name' do
      expect(profile.family_name.value).to eql('test_family_name')
    end
  end

  describe '.given_names' do
    it 'should return test_given_names' do
      expect(profile.given_names.value).to eql('test_given_names')
    end
  end

  describe '.full_name' do
    it 'should return test_full_name' do
      expect(profile.full_name.value).to eql('test_full_name')
    end
  end

  describe '.phone_number' do
    it 'should return test_phone_number' do
      expect(profile.phone_number.value).to eql('test_phone_number')
    end
  end

  describe '.email_address' do
    it 'should return test_email_address' do
      expect(profile.email_address.value).to eql('test_email_address')
    end
  end

  describe '.date_of_birth' do
    it 'should return test_date_of_birth' do
      expect(profile.date_of_birth.value).to eql('test_date_of_birth')
    end
  end

  describe '.gender' do
    it 'should return test_gender' do
      expect(profile.gender.value).to eql('test_gender')
    end
  end

  describe '.nationality' do
    it 'should return test_nationality' do
      expect(profile.nationality.value).to eql('test_nationality')
    end
  end

  describe '.document_images' do
    it 'should return test_document_images' do
      expect(profile.document_images.value).to eql('test_document_images')
    end
  end

  describe '.postal_address' do
    it 'should return test_postal_address' do
      expect(profile.postal_address.value).to eql('test_postal_address')
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
      expect(profile.structured_postal_address.value).to eql('test_structured_address')
    end
  end

  describe '.document_details' do
    it 'should return test_document_details' do
      expect(profile.document_details.value).to eql('test_document_details')
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
      expect(profile.attributes.length).to eql(17)
      profile_values.each do |key, value|
        expect(profile.attributes[key].value).to eql(value)
      end
    end
  end

  describe '.age_verifications' do
    it 'should return all age verifications' do
      expect(profile.age_verifications.length).to eql(4)
      profile.age_verifications.each do |value|
        expect(value).to be_a(Yoti::AgeVerification)
      end
    end
    it 'should return empty array when there are no age verifications' do
      empty_profile = Yoti::Profile.new({})
      expect(empty_profile.age_verifications).to be_a(Array)
      expect(empty_profile.age_verifications.length).to eql(0)
    end
  end

  describe '.find_age_under_verification' do
    it 'should find unsuccessful age under verification' do
      verification = profile.find_age_under_verification(18)
      expect(verification.age).to eql(18)
      expect(verification.check_type).to eql('age_under')
      expect(verification.result).to eql(false)
    end
    it 'should find successful age under verification' do
      verification = profile.find_age_under_verification(21)
      expect(verification.age).to eql(21)
      expect(verification.check_type).to eql('age_under')
      expect(verification.result).to eql(true)
    end
    it 'should return NULL for no match' do
      verification = profile.find_age_under_verification(100)
      expect(verification).to be_nil
    end
  end

  describe '.find_age_over_verification' do
    it 'should find unsuccessful age over verification' do
      verification = profile.find_age_over_verification(21)
      expect(verification.age).to eql(21)
      expect(verification.check_type).to eql('age_over')
      expect(verification.result).to eql(false)
    end
    it 'should find successful age over verification' do
      verification = profile.find_age_over_verification(18)
      expect(verification.age).to eql(18)
      expect(verification.check_type).to eql('age_over')
      expect(verification.result).to eql(true)
    end
    it 'should return NULL for no match' do
      verification = profile.find_age_over_verification(100)
      expect(verification).to be_nil
    end
  end

  context 'with multiple attributes of the same name' do
    let :multiname_profile do
      Yoti::Profile.new([
                          Yoti::Attribute.new(Yoti::Attribute::FULL_NAME, 'Name 1', {}, {}),
                          Yoti::Attribute.new(Yoti::Attribute::FULL_NAME, 'Name 2', {}, {}),
                          Yoti::Attribute.new(Yoti::Attribute::FULL_NAME, 'Name 3', {}, {})
                        ])
    end

    describe '.get_all_attributes_by_name' do
      it 'returns all the names' do
        expect(
          multiname_profile.get_all_attributes_by_name(Yoti::Attribute::FULL_NAME)
          .length
        ).to eql 3
        expect(
          multiname_profile.get_all_attributes_by_name(Yoti::Attribute::FULL_NAME)[0]
          .value
        ).to eql 'Name 1'
        expect(
          multiname_profile.get_all_attributes_by_name(Yoti::Attribute::FULL_NAME)[1]
          .value
        ).to eql 'Name 2'
        expect(
          multiname_profile.get_all_attributes_by_name(Yoti::Attribute::FULL_NAME)[2]
          .value
        ).to eql 'Name 3'
      end
    end

    describe '.attribute_list' do
      it 'returns all the attributes' do
        expect(multiname_profile.attribute_list.length).to eql 3
        expect(multiname_profile.attribute_list[0].value).to eql 'Name 1'
        expect(multiname_profile.attribute_list[1].value).to eql 'Name 2'
        expect(multiname_profile.attribute_list[2].value).to eql 'Name 3'
      end
    end
  end
end
