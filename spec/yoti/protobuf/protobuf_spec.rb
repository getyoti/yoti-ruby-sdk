require 'spec_helper'

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

      it 'raises a ProtobufError' do
        error = 'The content type is invalid.'
        expect { subject }.to raise_error(Yoti::ProtobufError, error)
      end
    end

    context 'when the content type is STRING' do
      let(:content_type) { :STRING }
      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
      end
    end

    context 'when the content type is DATE' do
      let(:content_type) { :DATE }

      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
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

    context 'when the content type is 5' do
      json_string = '{"test": "json string"}'
      let(:content_type) { :JSON }
      let(:value) { json_string }

      it 'parses the string to JSON' do
        expect(subject).to eql(JSON.parse(json_string))
      end
    end

    context 'when the content type is something else' do
      let(:content_type) { double }

      it 'returns the value' do
        is_expected.to eql(value)
      end
    end
  end

  describe '.image_uri_based_on_content_type' do
    let(:value) { 'test string' }
    subject { Yoti::Protobuf.image_uri_based_on_content_type(value, content_type) }

    context 'when the content type is JPEG' do
      let(:content_type) { :JPEG }
      it 'encodes the string to JPEG format' do
        is_expected.to eql('data:image/jpeg;base64,dGVzdCBzdHJpbmc=')
      end
    end

    context 'when the content type is PNG' do
      let(:content_type) { :PNG }

      it 'encodes the string to PNG format' do
        is_expected.to eql('data:image/png;base64,dGVzdCBzdHJpbmc=')
      end
    end
  end
end
