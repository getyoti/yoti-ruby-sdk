require 'spec_helper'

def activity_details(receipt, attr_arr, application_attr_arr = nil)
  Yoti::ActivityDetails.new(
    receipt,
    proto_attr_list(attr_arr),
    proto_attr_list(application_attr_arr)
  )
end

def proto_attr_list(attr_arr)
  return {} if attr_arr.nil?

  attr_list = Yoti::Protobuf::Attrpubapi::AttributeList.new
  attr_arr.each do |attr|
    attr_list.attributes.push(attr)
  end
  attr_list
end

def proto_attr(name, value, content_type)
  attr = Yoti::Protobuf::Attrpubapi::Attribute.new
  attr.name = name
  attr.value = value
  attr.content_type = content_type
  attr
end

describe 'Yoti::ActivityDetails' do
  describe '#initialize' do
    it 'sets the instance variables' do
      receipt = {
        'remember_me_id' => 'test_remember_me_id',
        'parent_remember_me_id' => 'test_parent_remember_me_id',
        'sharing_outcome' => 'SUCCESS',
        'timestamp' => '2016-07-19T08:55:38Z'
      }
      activity_details = activity_details(receipt, [])

      expect(activity_details.user_id).to eql('test_remember_me_id')
      expect(activity_details.remember_me_id).to eql('test_remember_me_id')
      expect(activity_details.parent_remember_me_id).to eql('test_parent_remember_me_id')
      expect(activity_details.outcome).to eql('SUCCESS')
      expect(activity_details.timestamp).to be_an_instance_of(Time)
      expect(activity_details.timestamp.to_s).to eql('2016-07-19 08:55:38 UTC')
      expect(activity_details.extra_data).to be_nil
    end
  end

  describe '#timestamp' do
    context 'when timestamp has microseconds' do
      it 'returns microseconds' do
        receipt = {
          'timestamp' => '2016-07-19T08:55:38.123456Z'
        }
        activity_details = activity_details(receipt, [])

        expect(activity_details.timestamp.strftime('%F %H:%M:%S.%6N')).to eql('2016-07-19 08:55:38.123456')
      end
    end
  end

  describe '#extra_data' do
    context 'with extra data' do
      let :extra_data do
        instance_double('ExtraData', list: [])
      end
      let :activity_details do
        Yoti::ActivityDetails.new({
                                    'remember_me_id' => 'test_remember_me_id',
                                    'parent_remember_me_id' => 'test_parent_remember_me_id',
                                    'sharing_outcome' => 'SUCCESS',
                                    'timestamp' => '2016-07-19T08:55:38Z'
                                  }, nil, nil, extra_data)
      end
      it 'returns the extra data' do
        expect(activity_details.extra_data).to eql extra_data
      end
    end
  end

  describe '#remember_me_id' do
    context 'when remember_me_id is empty string' do
      it 'returns empty string' do
        receipt = {
          'remember_me_id' => '',
          'sharing_outcome' => 'SUCCESS'
        }
        activity_details = activity_details(receipt, [])

        expect(activity_details.remember_me_id).to eql('')
        expect(activity_details.outcome).to eql('SUCCESS')
      end
    end
    context 'when remember_me_id is not present' do
      it 'returns nil' do
        receipt = {
          'sharing_outcome' => 'SUCCESS'
        }
        activity_details = activity_details(receipt, [])

        expect(activity_details.remember_me_id).to be_nil
        expect(activity_details.outcome).to eql('SUCCESS')
      end
    end
  end

  describe '#parent_remember_me_id' do
    context 'when parent_remember_me_id is empty string' do
      it 'returns empty string' do
        receipt = {
          'parent_remember_me_id' => '',
          'sharing_outcome' => 'SUCCESS'
        }
        activity_details = activity_details(receipt, [])

        expect(activity_details.parent_remember_me_id).to eql('')
        expect(activity_details.outcome).to eql('SUCCESS')
      end
    end
    context 'when parent_remember_me_id is not present' do
      it 'returns nil' do
        receipt = {
          'sharing_outcome' => 'SUCCESS'
        }
        activity_details = activity_details(receipt, [])

        expect(activity_details.parent_remember_me_id).to be_nil
        expect(activity_details.outcome).to eql('SUCCESS')
      end
    end
  end

  describe '#profile' do
    it 'returns the Yoti::Profile with processed attributes' do
      attr_arr = [
        proto_attr('selfie', 'test_selfie_value', :JPEG),
        proto_attr('phone_number', '+447474747474', :STRING),
        proto_attr('test_integer', '123', :INT),
        proto_attr('structured_postal_address', '{"formatted_address":"test_structured_address"}', :JSON)
      ]
      activity_details = activity_details({}, attr_arr)

      expect(activity_details.profile).to be_an_instance_of(Yoti::Profile)

      expect(activity_details.profile.selfie).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.selfie.value).to eql('test_selfie_value')

      expect(activity_details.profile.phone_number).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.phone_number.value).to eql('+447474747474')

      expect(activity_details.profile.structured_postal_address).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.structured_postal_address.value['formatted_address']).to eql('test_structured_address')

      expect(activity_details.profile.get_attribute('test_integer')).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.get_attribute('test_integer').value).to eql(123)
    end

    it 'includes unknown attributes that can be converted' do
      @log_output = StringIO.new
      Yoti::Log.output(@log_output)

      attr_arr = [
        proto_attr('unknown_string_value', 'test_string', 200),
        proto_attr('full_name', 'test name', :STRING)
      ]
      activity_details = activity_details({}, attr_arr)

      expect(activity_details.profile.full_name.value).to eql('test name')

      expect(activity_details.profile.get_attribute('unknown_string_value')).to be_an_instance_of(Yoti::Attribute)
      expect(activity_details.profile.get_attribute('unknown_string_value').value).to eql('test_string')

      expect(@log_output.string).to include "WARN -- Yoti: Unknown Content Type '200', parsing as a String"
    end

    it 'excludes attributes that cannot be converted' do
      @log_output = StringIO.new
      Yoti::Log.output(@log_output)

      attr_arr = [
        proto_attr('unknown_image_value', Base64.decode64('R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='), 100),
        proto_attr('full_name', 'test name', :STRING)
      ]
      activity_details = activity_details({}, attr_arr)

      expect(activity_details.profile.full_name.value).to eql('test name')

      expect(activity_details.profile.get_attribute('unknown_image_value')).to be_nil

      expect(@log_output.string).to include 'WARN -- Yoti: "\x80" from ASCII-8BIT to UTF-8 (Attribute: unknown_image_value)'
      expect(@log_output.string).to include "WARN -- Yoti: Unknown Content Type '100', parsing as a String"
    end

    it 'includes string attributes that are empty' do
      @log_output = StringIO.new
      Yoti::Log.output(@log_output)

      attr_arr = [
        proto_attr('full_name', 'test name', :STRING),
        proto_attr('empty_string_value', '', :STRING)
      ]
      activity_details = activity_details({}, attr_arr)

      expect(activity_details.profile.full_name.value).to eql('test name')

      expect(activity_details.profile.get_attribute('empty_string_value').value).to eql('')
      expect(@log_output.string).to eql('')
    end

    it 'excludes non-string attributes that are empty' do
      %i[
        UNDEFINED
        JPEG
        DATE
        PNG
        JSON
        MULTI_VALUE
        INT
      ].each do |content_type|
        @log_output = StringIO.new
        Yoti::Log.output(@log_output)

        attr_arr = [
          proto_attr('full_name', 'test name', :STRING),
          proto_attr('empty_non_string_value', '', content_type)
        ]
        activity_details = activity_details({}, attr_arr)

        expect(activity_details.profile.full_name.value).to eql('test name')
        expect(activity_details.profile.get_attribute('empty_non_string_value')).to be_nil
        expect(@log_output.string).to include 'WARN -- Yoti: Warning: value is NULL (Attribute: empty_non_string_value)'
      end
    end
  end

  describe '#application_profile' do
    it 'returns the Yoti::ApplicationProfile with processed attributes' do
      attr_arr = [
        proto_attr('application_name', 'test application name', :STRING),
        proto_attr('application_logo', 'some logo content', :JPEG),
        proto_attr('application_url', 'https://www.example.com', :STRING),
        proto_attr('application_receipt_bgcolor', '#000000', :STRING)
      ]
      activity_details = activity_details({}, {}, attr_arr)
      application_profile = activity_details.application_profile

      expect(application_profile).to be_an_instance_of(Yoti::ApplicationProfile)

      expect(application_profile.name).to be_an_instance_of(Yoti::Attribute)
      expect(application_profile.name.value).to eql('test application name')

      expect(application_profile.logo).to be_an_instance_of(Yoti::Attribute)
      base64_content = "data:image/jpeg;base64,#{Base64.strict_encode64('some logo content')}"
      expect(application_profile.logo.value.base64_content).to eql(base64_content)

      expect(application_profile.url).to be_an_instance_of(Yoti::Attribute)
      expect(application_profile.url.value).to eql('https://www.example.com')

      expect(application_profile.receipt_bgcolor).to be_an_instance_of(Yoti::Attribute)
      expect(application_profile.receipt_bgcolor.value).to eql('#000000')

      expect(application_profile.get_attribute('application_name')).to be_an_instance_of(Yoti::Attribute)
      expect(application_profile.get_attribute('application_name').value).to eql('test application name')
    end
  end

  describe '#structured_postal_address' do
    it 'returns structured_postal_address' do
      attr_arr = [
        proto_attr('structured_postal_address', '{"formatted_address":"test_structured_address"}', :JSON)
      ]
      activity_details = activity_details({}, attr_arr)

      expect(activity_details.structured_postal_address['formatted_address']).to eql('test_structured_address')
    end
  end
end
