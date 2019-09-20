# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::DynamicScenario' do
  let :policy do
    Yoti::DynamicSharingService::DynamicPolicy
      .builder
      .with_full_name
      .with_age_over(18)
      .with_pin_auth
      .build
  end

  let :extension do
    Yoti::DynamicSharingService::Extension
      .builder
      .with_type('TEST TYPE')
      .with_content('TEST CONTENT')
      .build
  end

  describe '.to_json' do
    let :scenario do
      Yoti::DynamicSharingService::DynamicScenario
        .builder
        .with_policy(policy)
        .with_extension(extension)
        .with_callback_endpoint('127.0.0.1')
        .build
    end
    it 'marshals the scenario' do
      expected = '{"extensions":[{"type":"TEST TYPE","content":"TEST CONTENT"}],"policy":{"wanted_auth_types":[2],"wanted":[{"name":"full_name"},{"name":"date_of_birth","derivation":"age_over:18"}]},"callback_endpoint":"127.0.0.1"}'
      expect(scenario.to_json).to eql expected
    end
  end

  describe '.builder' do
    describe '.with_policy' do
      let :scenario do
        Yoti::DynamicSharingService::DynamicScenario
          .builder
          .with_policy(policy)
          .build
      end
      it 'sets the policy' do
        expect(scenario.policy.wanted.length).to eql 2
        expect(scenario.policy.wanted_auth_types.length).to eql 1
        expect(scenario.policy.wanted_auth_types.first).to eql(
          Yoti::DynamicSharingService::DynamicPolicy::PIN_AUTH_TYPE
        )
      end
    end

    describe '.with_extension' do
      let :scenario do
        Yoti::DynamicSharingService::DynamicScenario
          .builder
          .with_extension(extension)
          .build
      end
      it 'sets an extension' do
        expect(scenario.extensions.length).to eql 1
        expect(scenario.extensions.first.type).to eql 'TEST TYPE'
      end
    end

    describe '.with_callback_endpoint' do
      let :scenario do
        Yoti::DynamicSharingService::DynamicScenario
          .builder
          .with_callback_endpoint('127.0.0.1')
          .build
      end
      it 'sets the callback endpoint' do
        expect(scenario.callback_endpoint).to eql '127.0.0.1'
      end
    end
  end
end
