require 'spec_helper'

describe 'Yoti::DocumentDetails' do
  context 'when an empty value is provided' do
    it 'should raise an error' do
      expect { Yoti::DocumentDetails.new('') }
        .to raise_error(ArgumentError, 'Invalid value for Yoti::DocumentDetails')
    end
  end

  context 'when there is one optional attribute' do
    document_details = Yoti::DocumentDetails.new('PASSPORT GBR 01234567 2020-01-01')
    describe '.type' do
      it 'should return PASSPORT' do
        expect(document_details.type).to eql('PASSPORT')
      end
    end
    describe '.issuing_country' do
      it 'should return GBR' do
        expect(document_details.issuing_country).to eql('GBR')
      end
    end
    describe '.document_number' do
      it 'should return 01234567' do
        expect(document_details.document_number).to eql('01234567')
      end
    end
    describe '.expiration_date' do
      it 'should return 2020-01-01' do
        expect(document_details.expiration_date).to be_a_kind_of(DateTime)
        expect(document_details.expiration_date.to_s).to eql('2020-01-01T00:00:00+00:00')
      end
    end
  end

  context 'when there are no optional attributes' do
    let :document_details do
      Yoti::DocumentDetails.new('DRIVING_LICENCE GBR 1234abc')
    end
    describe '.type' do
      it 'should return DRIVING_LICENCE' do
        expect(document_details.type).to eql 'DRIVING_LICENCE'
      end
    end
    describe '.issuing_country' do
      it 'should return GBR' do
        expect(document_details.issuing_country).to eql 'GBR'
      end
    end
    describe '.document_number' do
      it 'should return 1234abc' do
        expect(document_details.document_number).to eql('1234abc')
      end
    end
    describe '.expiration_date' do
      it 'should return nil' do
        expect(document_details.expiration_date).to be_nil
      end
    end
  end

  context 'when there are two optional attributes' do
    document_details = Yoti::DocumentDetails.new('DRIVING_LICENCE GBR 1234abc 2016-05-01 DVLA')
    describe '.type' do
      it 'should return DRIVING_LICENCE' do
        expect(document_details.type).to eql('DRIVING_LICENCE')
      end
    end
    describe '.issuing_country' do
      it 'should return GBR' do
        expect(document_details.issuing_country).to eql('GBR')
      end
    end
    describe '.document_number' do
      it 'should return 1234abc' do
        expect(document_details.document_number).to eql('1234abc')
      end
    end
    describe '.expiration_date' do
      it 'should return 2016-05-01' do
        expect(document_details.expiration_date).to be_a_kind_of(DateTime)
        expect(document_details.expiration_date.to_s).to eql('2016-05-01T00:00:00+00:00')
      end
    end
    describe '.issuing_authority' do
      it 'should return DVLA' do
        expect(document_details.issuing_authority).to eql('DVLA')
      end
    end
  end

  context 'when value is empty' do
    it 'should raise ArgumentError' do
      expect { Yoti::DocumentDetails.new('') }
        .to raise_error(ArgumentError, 'Invalid value for Yoti::DocumentDetails')
    end
  end

  context 'when the expiration date is missing' do
    document_details = Yoti::DocumentDetails.new('PASS_CARD GBR 22719564893 - CITIZENCARD')
    describe '.expiration_date' do
      it 'should return null' do
        expect(document_details.expiration_date).to be_nil
      end
    end
    describe '.issuing_authority' do
      it 'should return issuing authority' do
        expect(document_details.issuing_authority).to eql('CITIZENCARD')
      end
    end
  end

  context 'when the expiration date is invalid' do
    it 'should raise ArgumentError' do
      expect { Yoti::DocumentDetails.new('PASSPORT GBR 1234abc X016-05-01') }
        .to raise_error(ArgumentError, 'invalid date')
    end
  end

  context 'when the value is less than three words' do
    it 'should raise ArgumentError' do
      expect { Yoti::DocumentDetails.new('PASS_CARD GBR') }
        .to raise_error(ArgumentError, 'Invalid value for Yoti::DocumentDetails')
    end
  end

  context 'when the value has six attributes' do
    it 'should ignore the sixth attribute' do
      document_details = Yoti::DocumentDetails.new('DRIVING_LICENCE GBR 1234abc 2016-05-01 DVLA someThirdAttribute')
      expect(document_details.type).to eql('DRIVING_LICENCE')
      expect(document_details.issuing_country).to eql('GBR')
      expect(document_details.document_number).to eql('1234abc')
      expect(document_details.expiration_date.to_s).to eql('2016-05-01T00:00:00+00:00')
    end
  end

  context 'when the document number is valid' do
    [
      '****',
      '~!@#$%^&*()-_=+[]{}|;\':,./<>?',
      '""',
      '\\',
      '"',
      '\'\'',
      '\''
    ].each do |value|
      it "#{value} should be allowed as document number" do
        document_details = Yoti::DocumentDetails.new("some-type some-country #{value} - some-authority")
        expect(document_details.document_number).to eql(value)
      end
    end
  end

  context 'when the value contains extra spaces' do
    [
      'some-type   some-country some-doc-number - some-authority',
      'some-type some-country  some-doc-number - some-authority',
      'some-type some-country some-doc-number  - some-authority',
      'some-type some-country some-doc-number -  some-authority'
    ].each do |value|
      it "should raise an ArgumentError for '#{value}''" do
        expect { Yoti::DocumentDetails.new(value) }
          .to raise_error(ArgumentError, 'Invalid value for Yoti::DocumentDetails')
      end
    end
  end
end
