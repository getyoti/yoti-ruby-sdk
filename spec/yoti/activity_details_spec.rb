require 'spec_helper'

def activity_details
  profile_json = JSON.parse(File.read('spec/sample-data/responses/profile.json'))
  receipt = profile_json['receipt']
  encrypted_data = Yoti::Protobuf.current_user(receipt)
  unwrapped_key = Yoti::SSL.decrypt_token(receipt['wrapped_receipt_key'])
  decrypted_data = Yoti::SSL.decipher(unwrapped_key, encrypted_data.iv, encrypted_data.cipher_text)
  decrypted_profile = Yoti::Protobuf.attribute_list(decrypted_data)
  Yoti::ActivityDetails.new(receipt, decrypted_profile)
end

describe 'Yoti::ActivityDetails' do
  describe '#initialize' do
    it 'sets the instance variables' do
      remember_me_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
      expect(activity_details.user_id).to eql(remember_me_id)
      expect(activity_details.remember_me_id).to eql(remember_me_id)
      expect(activity_details.parent_remember_me_id).to eql('f5RjVQMyoKOvO/hkv43Ik+t6d6mGfP2tdrNijH4k4qafTG0FSNUgQIvd2Z3Nx1j8')
      expect(activity_details.outcome).to eql('SUCCESS')
    end
  end

  describe '#profile' do
    it 'returns the Yoti::Profile with processed attributes' do
      expect(activity_details.profile).to be_an_instance_of(Yoti::Profile)
      expect(activity_details.profile.selfie).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.phone_number).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.phone_number.value).to eql('+447474747474')
    end
  end

  describe '#structured_postal_address' do
    it 'returns structured_postal_address' do
      expect(activity_details.structured_postal_address).to eql(nil)
    end
  end
end
