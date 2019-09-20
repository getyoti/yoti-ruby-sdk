# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DynamicSharingService::TransactionalFlowExtension' do
  describe '.type' do
    let :ext do
      Yoti::DynamicSharingService::TransactionalFlowExtension
        .builder
        .build
    end
    it 'has the transactional flow extension type' do
      expect(ext.type).to eql Yoti::DynamicSharingService::TransactionalFlowExtension::EXTENSION_TYPE
    end
  end

  describe '.builder' do
    describe '.with_content' do
      let :ext do
        Yoti::DynamicSharingService::TransactionalFlowExtension
          .builder
          .with_content('TEST CONTENT')
          .build
      end
      it 'sets the content' do
        expect(ext.content).to eql 'TEST CONTENT'
      end
    end
  end
end
