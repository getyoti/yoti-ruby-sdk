require 'spec_helper'

describe 'Yoti::Protobuf' do
  describe '.current_user' do
    let(:receipt) { { 'other_party_profile_content' => 'test text' } }

    context 'when the receipt is missing the other_party_profile_content key' do
      it 'raises a ProtobufError' do
        error = 'The receipt has invalid data'
        expect { Yoti::Protobuf.current_user({}) }.to raise_error(Yoti::ProtobufError, error)
      end
    end

    context 'when the receipt is valid' do
      it 'returns a Yoti::Protobuf::V1::EncryptedData object' do
        expect(Yoti::Protobuf.current_user(receipt)).to be_a(Yoti::Protobuf::V1::Compubapi::EncryptedData)
      end
    end
  end

  describe '.value_based_on_content_type' do
    let(:value) { 'test string' }
    let(:value_encoded) { 'test string'.encode('ISO-8859-1') }
    subject { Yoti::Protobuf.value_based_on_content_type(value, content_type) }

    context 'when the content type is 0' do
      let(:content_type) { 0 }

      it 'raises a ProtobufError' do
        error = 'Wrong content type'
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

    context 'when the content type is 2' do
      let(:content_type) { 2 }
      it 'encodes the string to JPEG format' do
        is_expected.to eql('data:image/jpeg;base64,dGVzdCBzdHJpbmc=')
      end
    end

    context 'when the content type is 3' do
      let(:content_type) { 3 }

      it 'encodes the string to UTF8' do
        expect(value_encoded.encoding.name).to_not eql('UTF-8')
        expect(subject.encoding.name).to eql('UTF-8')
      end
    end

    context 'when the content type is 4' do
      let(:content_type) { 4 }

      it 'encodes the string to PNG format' do
        is_expected.to eql('data:image/png;base64,dGVzdCBzdHJpbmc=')
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
