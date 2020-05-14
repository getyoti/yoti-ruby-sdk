# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::DocumentAuthenticityCheck' do
  let :check do
    Yoti::DocScan::Session::Create::DocumentAuthenticityCheck
      .builder
      .build
  end

  describe '.to_json' do
    it 'serializes the check' do
      expected = {
        type: 'ID_DOCUMENT_AUTHENTICITY'
      }

      expect(check.as_json).to eql expected
      expect(check.to_json).to eql expected.to_json
    end
  end
end
