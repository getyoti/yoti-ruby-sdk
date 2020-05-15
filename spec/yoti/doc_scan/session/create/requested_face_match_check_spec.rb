# frozen_string_literal: true

require 'spec_helper'

describe 'Yoti::DocScan::Session::Create::RequestedFaceMatchCheck' do
  describe '.to_json' do
    describe 'with manual check always' do
      it 'serializes the check' do
        check = Yoti::DocScan::Session::Create::RequestedFaceMatchCheck
                .builder
                .with_manual_check_always
                .build

        expected = {
          type: 'ID_DOCUMENT_FACE_MATCH',
          config: {
            manual_check: 'ALWAYS'
          }
        }

        expect(check.as_json).to eql expected
        expect(check.to_json).to eql expected.to_json
      end
    end

    describe 'with manual check never' do
      it 'serializes the check' do
        check = Yoti::DocScan::Session::Create::RequestedFaceMatchCheck
                .builder
                .with_manual_check_never
                .build

        expected = {
          type: 'ID_DOCUMENT_FACE_MATCH',
          config: {
            manual_check: 'NEVER'
          }
        }

        expect(check.as_json).to eql expected
        expect(check.to_json).to eql expected.to_json
      end
    end

    describe 'with manual check fallback' do
      it 'serializes the check' do
        check = Yoti::DocScan::Session::Create::RequestedFaceMatchCheck
                .builder
                .with_manual_check_fallback
                .build

        expected = {
          type: 'ID_DOCUMENT_FACE_MATCH',
          config: {
            manual_check: 'FALLBACK'
          }
        }

        expect(check.as_json).to eql expected
        expect(check.to_json).to eql expected.to_json
      end
    end
  end
end
