# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::RequestedDocumentAuthenticityCheck' do
  it 'serializes correctly' do
    check = Yoti::DocScan::Session::Create::RequestedDocumentAuthenticityCheck
            .builder
            .build

    expected = {
      type: 'ID_DOCUMENT_AUTHENTICITY',
      config: {}
    }

    expect(check.to_json).to eql expected.to_json
  end
end
