require 'spec_helper'

describe 'Yoti::ActivityDetails' do
  let(:receipt) { { 'remember_me_id' => '123qweasd', 'sharing_outcome' => 'SUCCESS' } }
  let(:activity_details) { Yoti::ActivityDetails.new(receipt) }

  describe '#initialize' do
    it 'sets the instance variables' do
      expect(activity_details.user_id).to eql('123qweasd')
      expect(activity_details.outcome).to eql('SUCCESS')
    end
  end
end
