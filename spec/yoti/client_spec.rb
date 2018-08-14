require 'spec_helper'

describe 'Yoti::Client' do
  describe '.get_activity_details' do
    let(:encrypted_connect_token) { File.read('spec/sample-data/encrypted_connect_token.txt', encoding: 'utf-8') }
    let(:profile) { activity_details.user_profile }
    let(:outcome) { activity_details.outcome }
    let(:user_id) { activity_details.user_id }
    let(:base64_selfie_uri) { activity_details.base64_selfie_uri }

    context 'when the encrypted token is nil', type: :api_with_profile do
      it 'raises an ArgumentError' do
        error = 'wrong number of arguments (given 0, expected 1)'
        expect { Yoti::Client.get_activity_details }.to raise_error(ArgumentError, error)
      end
    end

    context 'when the encrypted token is valid', type: :api_with_profile do
      let(:activity_details) { Yoti::Client.get_activity_details(encrypted_connect_token) }

      it 'returns an ActivityDetails object' do
        expect(activity_details).to be_a(Yoti::ActivityDetails)
      end

      it 'contains the outcome with a successful value' do
        expect(outcome).to eql 'SUCCESS'
      end
    end

    context 'when the profile has content', type: :api_with_profile do
      let(:activity_details) { Yoti::Client.get_activity_details(encrypted_connect_token) }

      it 'contains the fetched profile' do
        expect(profile).not_to be_nil
      end

      it 'contains the decrypted user ID value' do
        expected_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
        expect(user_id).to eql(expected_id)
      end

      it 'contains the decrypted phone number value' do
        phone_number = '+447474747474'
        expect(profile['phone_number']).to eql(phone_number)
      end

      it 'contains the decrypted selfie value' do
        selfie = File.read('spec/sample-data/selfie.txt', encoding: 'utf-8')
        expect('data:image/jpeg;base64,'.concat(Base64.strict_encode64(profile['selfie']))).to eql(selfie)
      end

      it 'contains the base64_selfie_uri value' do
        selfie = File.read('spec/fixtures/selfie.txt', encoding: 'utf-8')
        expect(base64_selfie_uri).to eql(selfie)
      end
    end

    context 'when the profile is empty', type: :api_with_empty_profile do
      let(:activity_details) { Yoti::Client.get_activity_details(encrypted_connect_token) }

      it 'contains the fetched profile' do
        expect(profile).to be_empty
      end

      it 'contains the decrypted user ID value' do
        expected_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
        expect(user_id).to eql(expected_id)
      end
    end

    context 'when the profile is null', type: :api_with_null_profile do
      let(:activity_details) { Yoti::Client.get_activity_details(encrypted_connect_token) }

      it 'contains the fetched profile' do
        expect(profile).to be_empty
      end

      it 'contains the decrypted user ID value' do
        expected_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
        expect(user_id).to eql(expected_id)
      end
    end

    context 'when the profile is missing', type: :api_without_profile do
      let(:activity_details) { Yoti::Client.get_activity_details(encrypted_connect_token) }

      it 'contains the fetched profile' do
        expect(profile).to be_empty
      end

      it 'contains the decrypted user ID value' do
        expected_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
        expect(user_id).to eql(expected_id)
      end
    end
  end

  describe '.aml_check' do
    context 'without an aml_profile' do
      it 'raises an ArgumentError' do
        error = 'wrong number of arguments (given 0, expected 1)'
        expect { Yoti::Client.aml_check }.to raise_error(ArgumentError, error)
      end
    end

    context 'with an aml_profile', type: :api_aml_check do
      let(:aml_address) { Yoti::AmlAddress.new('GBR') }
      let(:aml_profile) { Yoti::AmlProfile.new('first_name', 'last_name', aml_address) }
      let(:aml_check) { Yoti::Client.aml_check(aml_profile) }

      it 'contains the AML check response' do
        expect(aml_check['on_pep_list']).to eql(true)
        expect(aml_check['on_fraud_list']).to eql(false)
        expect(aml_check['on_watch_list']).to eql(false)
      end
    end
  end
end
