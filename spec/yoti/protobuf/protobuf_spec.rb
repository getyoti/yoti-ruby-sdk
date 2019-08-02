require 'spec_helper'

def assert_expected_image(image, mime_type, base64_last_ten)
  expect(image).to be_a(Yoti::Image)
  expect(image.mime_type).to eql(mime_type)
  expect(image.base64_content.chars.last(10).join).to eql(base64_last_ten)
end

describe 'Yoti::Protobuf' do
  describe '.current_user' do
    context 'when the receipt has a nil other_party_profile_content key' do
      let(:receipt) { { 'other_party_profile_content' => nil } }

      it 'returns nil' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_nil
      end
    end

    context 'when the receipt has an empty other_party_profile_content key' do
      let(:receipt) { { 'other_party_profile_content' => '' } }

      it 'returns nil' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_nil
      end
    end

    context 'when the receipt is missing the other_party_profile_content key' do
      let(:receipt) { {} }

      it 'returns nil' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_nil
      end
    end

    context 'when the receipt is valid' do
      profile_json = JSON.parse(File.read('spec/sample-data/responses/profile.json'))
      let(:receipt) { profile_json['receipt'] }

      it 'returns a Yoti::Protobuf::Compubapi::EncryptedData object' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_a(Yoti::Protobuf::Compubapi::EncryptedData)
      end
    end
  end

  describe '.attribute_list' do
    let(:data) { '' }

    it 'returns a Yoti::Protobuf::Attrpubapi::AttributeList object' do
      expect(Yoti::Protobuf.attribute_list(data)).to be_a(Yoti::Protobuf::Attrpubapi::AttributeList)
    end
  end

  describe '.value_based_on_content_type' do
    let(:value) { 'test string' }
    let(:value_encoded) { 'test string'.encode('ISO-8859-1') }
    subject { Yoti::Protobuf.value_based_on_content_type(value, content_type) }

    context 'when the content type is UNDEFINED' do
      let(:content_type) { :UNDEFINED }

      before(:each) do
        @log_output = StringIO.new
        Yoti::Log.output(@log_output)
      end

      it 'returns the value' do
        is_expected.to eql(value)
        expect(@log_output.string).to include "WARN -- Yoti: Unknown Content Type 'UNDEFINED', parsing as a String"
      end
    end

    context 'when the content type is STRING' do
      let(:content_type) { :STRING }
      context 'when the value is not empty' do
        it 'encodes the string to UTF8' do
          expect(value_encoded.encoding.name).to_not eql('UTF-8')
          expect(subject.encoding.name).to eql('UTF-8')
          expect(subject).to eql('test string')
        end
      end
      context 'when the value is empty' do
        let(:value) { '' }
        it 'encodes the string to UTF8' do
          expect(value_encoded.encoding.name).to_not eql('UTF-8')
          expect(subject.encoding.name).to eql('UTF-8')
          expect(subject).to eql('')
        end
      end
    end

    %i[
      UNDEFINED
      JPEG
      DATE
      PNG
      JSON
      MULTI_VALUE
      INT
    ].each do |content_type|
      context "when the content type is #{content_type}" do
        let(:content_type) { content_type }
        let(:value) { '' }
        context 'when the value is empty' do
          it 'raises an error' do
            expect { subject }.to raise_error(TypeError, 'Warning: value is NULL')
          end
        end
      end
    end

    context 'when the content type is DATE' do
      let(:content_type) { :DATE }

      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
      end
    end

    context 'when the content type is JPEG' do
      let(:content_type) { :JPEG }
      let(:value) { 'jpeg_image_content' }

      it 'encodes the string to JPEG image object' do
        expect(subject).to be_a(Yoti::ImageJpeg)
        expect(subject.base64_content).to eql("data:image/jpeg;base64,#{Base64.strict_encode64('jpeg_image_content')}")
      end
    end

    context 'when the content type is PNG' do
      let(:content_type) { :PNG }
      let(:value) { 'png_image_content' }

      it 'encodes the string to PNG image object' do
        expect(subject).to be_a(Yoti::ImagePng)
        expect(subject.base64_content).to eql("data:image/png;base64,#{Base64.strict_encode64('png_image_content')}")
      end
    end

    [0, 1, 123, -1, -10].each do |integer|
      context "when the content type is INT and value is string '#{integer}'" do
        let(:content_type) { :INT }
        let(:value) { integer.to_s }

        it "parses value to integer #{integer}" do
          expect(subject).to eql(integer)
        end
      end
    end

    context 'when the content type is JSON' do
      json_string = '{"test": "json string"}'
      let(:content_type) { :JSON }
      let(:value) { json_string }

      it 'parses the string to JSON' do
        expect(subject).to eql(JSON.parse(json_string))
      end
    end

    context 'when the content type is MULTI_VALUE' do
      multi_value_data = File.read('spec/sample-data/attributes/multi-value.txt')
      let(:value) { Yoti::Protobuf::Attrpubapi::Attribute.decode(Base64.decode64(multi_value_data)).value }
      let(:content_type) { :MULTI_VALUE }

      it 'parses the value to multi value' do
        expect(subject).to be_a(Yoti::MultiValue)
        assert_expected_image(subject.items[0], 'image/jpeg', 'vWgD//2Q==')
        assert_expected_image(subject.items[1], 'image/jpeg', '38TVEH/9k=')
      end
    end

    context 'when the content type is something else' do
      let(:content_type) { 100 }

      before(:each) do
        @log_output = StringIO.new
        Yoti::Log.output(@log_output)
      end

      it 'returns the value' do
        is_expected.to eql(value)
        expect(@log_output.string).to include "WARN -- Yoti: Unknown Content Type '100', parsing as a String"
      end
    end
  end

  describe '.value_based_on_attribute_name' do
    subject { Yoti::Protobuf.value_based_on_attribute_name(value, attr_name) }

    context 'when the name is document_images' do
      items = [
        'test_string',
        Yoti::ImageJpeg.new('image_1'),
        Yoti::ImagePng.new('image_2'),
        123,
        ['test_array']
      ]
      let(:value) { Yoti::MultiValue.new(items) }
      let(:attr_name) { Yoti::Attribute::DOCUMENT_IMAGES }

      it 'returns filtered array of images' do
        expect(subject).to be_a(Array)
        expect(subject.count).to eql(2)
        expect(subject).to be_frozen
        expect(subject[0]).to be_a(Yoti::ImageJpeg)
        expect(subject[1]).to be_a(Yoti::ImagePng)
      end
    end

    context 'when the name is document_details' do
      let(:value) { 'PASSPORT GBR 01234567 2016-05-01 DVLA' }
      let(:attr_name) { Yoti::Attribute::DOCUMENT_DETAILS }

      it 'returns document details object' do
        expect(subject).to be_a_kind_of(Yoti::DocumentDetails)
        expect(subject.type).to eql('PASSPORT')
        expect(subject.issuing_country).to eql('GBR')
        expect(subject.document_number).to eql('01234567')
        expect(subject.issuing_authority).to eql('DVLA')
        expect(subject.expiration_date).to be_a_kind_of(DateTime)
        expect(subject.expiration_date.to_s).to eql('2016-05-01T00:00:00+00:00')
      end
    end

    context 'when the name is document_images and the value is not a multi value' do
      let(:value) { 'a string' }
      let(:attr_name) { Yoti::Attribute::DOCUMENT_IMAGES }

      it 'raises as type error' do
        expect { subject }.to raise_error(TypeError, 'Document Images could not be decoded')
      end
    end
  end
end
