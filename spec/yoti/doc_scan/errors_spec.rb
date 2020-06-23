# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Error' do
  let(:some_error_message) { 'SOME_ERROR_MESSAGE' }
  let(:some_code) { 'SOME_CODE' }
  let(:some_message) { 'SOME_MESSAGE' }
  let(:some_property) { 'SOME_PROPERTY' }
  let(:some_property_message) { 'SOME_PROPERTY_MESSAGE' }
  let(:some_other_property) { 'SOME_OTHER_PROPERTY' }
  let(:some_other_property_message) { 'SOME_OTHER_PROPERTY_MESSAGE' }
  let(:some_response) { instance_double(Net::HTTPResponse, body: response_body, :[] => 'application/json') }
  let(:some_request_error) do
    Yoti::RequestError.new(some_error_message, some_response)
  end

  context 'when created with message' do
    let(:error) do
      Yoti::DocScan::Error.new(some_error_message)
    end

    it 'uses provided error message' do
      expect(error.message).to eql(some_error_message)
    end

    it 'is a Yoti::RequestError' do
      expect(error).to be_a(Yoti::RequestError)
    end
  end

  context 'when created with message and response' do
    let(:error) do
      Yoti::DocScan::Error.new(some_error_message, some_response)
    end
    let(:response_body) { { code: some_code, message: some_message }.to_json }

    it 'uses formatted response' do
      expect(error.message).to eql("#{some_code} - #{some_message}")
    end
  end

  context 'when wrapped error response has code and message' do
    let(:error) do
      Yoti::DocScan::Error.wrap(some_request_error)
    end
    let(:response_body) { { code: some_code, message: some_message }.to_json }

    it 'includes code and message in error message' do
      expect(error.message).to eql("#{some_code} - #{some_message}")
    end
  end

  context 'when wrapped error response has code, message and errors' do
    let(:error) do
      Yoti::DocScan::Error.wrap(some_request_error)
    end
    let(:response_body) do
      {
        code: some_code,
        message: some_message,
        errors: [
          {
            property: some_property,
            message: some_property_message
          },
          {
            property: some_other_property,
            message: some_other_property_message
          }
        ]
      }.to_json
    end

    it 'includes code, message and errors in error message' do
      error.message
      error.message
      expect(error.message)
        .to eql("#{some_code} - #{some_message}: #{some_property} \"#{some_property_message}\", #{some_other_property} \"#{some_other_property_message}\"")
    end
  end

  context 'when wrapped error response has no code or message' do
    let(:error) do
      Yoti::DocScan::Error.wrap(some_request_error)
    end
    let(:response_body) { { some: 'json' }.to_json }

    it 'uses wrapped error message with response' do
      expect(error.message).to eql("#{some_error_message}: #{response_body}")
    end
  end

  context 'when wrapped error response is not available' do
    let(:error) do
      Yoti::DocScan::Error.wrap(some_request_error)
    end
    let(:some_response) { nil }

    it 'uses wrapped error message' do
      expect(error.message).to eql(some_error_message)
    end
  end
end
