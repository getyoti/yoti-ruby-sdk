# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::create_share_url' do
  let :policy do
    Yoti::DynamicSharingService::DynamicPolicy
      .builder
      .with_given_names
      .build
  end
  let :scenario do
    Yoti::DynamicSharingService::DynamicScenario
      .builder
      .with_policy(policy)
      .with_callback_endpoint('127.0.0.1')
      .build
  end
  let :share do
    Yoti::DynamicSharingService.create_share_url scenario
  end

  context 'when the scenario is valid' do
    before(:context) do
      stub_api_requests_v1(:any, share_url, '[a-zA-Z]*', 201)
    end
    end
    it 'generates a share url' do
      expect(share.share_url).to eql 'https://code.yoti.com/forfhq3peurij4ihroiehg4jgiej'
      expect(share.ref_id).to eql '01aa2dea-d28b-11e6-bf26-cec0c932ce01'
    end
  end

  context 'when the scenario is invalid' do
    it 'returns an invalid data error' do
      expect { Yoti::DynamicSharingService.create_share_url scenario }.to raise_error(
        Yoti::DynamicSharingService::INVALID_DATA
      )
    end
  end

  context 'when the app id is not found' do
    it 'returns an application not found error' do
      expect { Yoti::DynamicSharingService.create_share_url scenario }.to raise_error(
        Yoti::DynamicSharingService::APPLICATION_NOT_FOUND
      )
    end
  end
end
