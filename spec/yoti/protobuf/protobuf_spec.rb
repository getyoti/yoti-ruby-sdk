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
      let(:receipt) { { 'other_party_profile_content' => 'test text' } }

      it 'returns a Yoti::Protobuf::V1::EncryptedData object' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_a(Yoti::Protobuf::V1::Compubapi::EncryptedData)
      end
    end
  end

  describe '.attribute_list' do
    let(:data) { '' }

    it 'returns a Yoti::Protobuf::V1::Attrpubapi::AttributeList object' do
      expect(Yoti::Protobuf.attribute_list(data)).to be_a(Yoti::Protobuf::V1::Attrpubapi::AttributeList)
    end
  end

  describe '.value_based_on_content_type' do
    let(:value) { 'test string' }
    let(:value_encoded) { 'test string'.encode('ISO-8859-1') }
    subject { Yoti::Protobuf.value_based_on_content_type(value, content_type) }

    context 'when the content type is 0' do
      let(:content_type) { 0 }

      it 'raises a ProtobufError' do
        error = 'The content type is invalid.'
        expect { subject }.to raise_error(Yoti::ProtobufError, error)
      end
    end

    context 'when the content type is 1' do
      let(:content_type) { 1 }
      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
      end
    end

    context 'when the content type is 3' do
      let(:content_type) { 3 }

      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
      end
    end

    context 'when the content type is something else' do
      let(:content_type) { double }

      it 'returns the value' do
        is_expected.to eql(value)
      end
    end
  end
end
