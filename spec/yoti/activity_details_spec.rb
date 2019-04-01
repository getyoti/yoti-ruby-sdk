require 'spec_helper'

def activity_details
  Yoti::ActivityDetails.new(
    {
      'remember_me_id' => 'test_remember_me_id',
      'parent_remember_me_id' => 'test_parent_remember_me_id',
      'sharing_outcome' => 'SUCCESS'
    },
    proto_attr_list(
      [
        proto_attr('selfie', 'test_selfie_value', :STRING),
        proto_attr('phone_number', '+447474747474', :STRING),
        proto_attr('test_integer', '123', :INT),
        proto_attr('structured_postal_address', '{"formatted_address":"test_structured_address"}', :JSON)
      ]
    )
  )
end

def proto_attr_list(attr_arr)
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
      expect(activity_details.user_id).to eql('test_remember_me_id')
      expect(activity_details.remember_me_id).to eql('test_remember_me_id')
      expect(activity_details.parent_remember_me_id).to eql('test_parent_remember_me_id')
      expect(activity_details.outcome).to eql('SUCCESS')
    end
  end

  describe '#profile' do
    it 'returns the Yoti::Profile with processed attributes' do
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
  end

  describe '#structured_postal_address' do
    it 'returns structured_postal_address' do
      expect(activity_details.structured_postal_address['formatted_address']).to eql('test_structured_address')
    end
  end
end
