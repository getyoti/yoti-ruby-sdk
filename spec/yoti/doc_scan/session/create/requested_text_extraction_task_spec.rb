# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::RequestedTextExtractionTask' do
  describe 'with manual check always' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
              .builder
              .with_manual_check_always
              .build

      expected = {
        type: 'ID_DOCUMENT_TEXT_DATA_EXTRACTION',
        config: {
          manual_check: 'ALWAYS'
        }
      }

      expect(check.to_json).to eql expected.to_json
    end
  end

  describe 'with manual check never' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
              .builder
              .with_manual_check_never
              .build

      expected = {
        type: 'ID_DOCUMENT_TEXT_DATA_EXTRACTION',
        config: {
          manual_check: 'NEVER'
        }
      }

      expect(check.to_json).to eql expected.to_json
    end
  end

  describe 'with manual check fallback' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
              .builder
              .with_manual_check_fallback
              .build

      expected = {
        type: 'ID_DOCUMENT_TEXT_DATA_EXTRACTION',
        config: {
          manual_check: 'FALLBACK'
        }
      }

      expect(check.to_json).to eql expected.to_json
    end
  end

  describe 'with chip data desired' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
              .builder
              .with_manual_check_never
              .with_chip_data_desired
              .build

      expected = {
        type: 'ID_DOCUMENT_TEXT_DATA_EXTRACTION',
        config: {
          manual_check: 'NEVER',
          chip_data: 'DESIRED'
        }
      }

      expect(check.to_json).to eql expected.to_json
    end
  end

  describe 'with chip data ignore' do
    it 'serializes correctly' do
      check = Yoti::DocScan::Session::Create::RequestedTextExtractionTask
              .builder
              .with_manual_check_never
              .with_chip_data_ignore
              .build

      expected = {
        type: 'ID_DOCUMENT_TEXT_DATA_EXTRACTION',
        config: {
          manual_check: 'NEVER',
          chip_data: 'IGNORE'
        }
      }

      expect(check.to_json).to eql expected.to_json
    end
  end
end
